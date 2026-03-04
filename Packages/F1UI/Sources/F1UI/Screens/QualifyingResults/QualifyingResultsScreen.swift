import F1Domain
import F1UseCases
import SwiftUI

public struct QualifyingResultsScreen: View {
    @State private var state: ViewState

    private let seasonId: Season.ID
    private let round: Race.Round
    private let getQualifyingResultsPage: @Sendable (Season.ID, Race.Round, PageRequest) async throws -> Page<QualifyingResult>
    private let pageLimit: Int

    public init(
        seasonId: Season.ID,
        round: Race.Round,
        getQualifyingResultsPageUseCase: GetQualifyingResultsPageUseCase,
        pageLimit: Int = 30
    ) {
        self.seasonId = seasonId
        self.round = round
        self.getQualifyingResultsPage = { seasonId, round, request in
            try await getQualifyingResultsPageUseCase(seasonId: seasonId, round: round, request: request)
        }
        self.pageLimit = pageLimit
        self._state = State(initialValue: .initial)
    }

    init(
        seasonId: Season.ID,
        round: Race.Round,
        getQualifyingResultsPage: @escaping @Sendable (Season.ID, Race.Round, PageRequest) async throws -> Page<QualifyingResult>,
        pageLimit: Int = 30
    ) {
        self.seasonId = seasonId
        self.round = round
        self.getQualifyingResultsPage = getQualifyingResultsPage
        self.pageLimit = pageLimit
        self._state = State(initialValue: .initial)
    }

    init(seasonId: Season.ID, round: Race.Round, previewState: ViewState) {
        self.seasonId = seasonId
        self.round = round
        self.getQualifyingResultsPage = { seasonId, round, request in
            _ = seasonId
            _ = round
            return try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.pageLimit = 30
        self._state = State(initialValue: previewState)
    }

    public var body: some View {
        content
            .navigationTitle("\(seasonId.rawValue) R\(round.rawValue) Qualifying")
            .task {
                if shouldLoadInitialPage {
                    await loadInitialPage()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if state.isLoadingInitial {
            ProgressView("Loading qualifying results...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if state.items.isEmpty, let error = state.error {
            ContentUnavailableView {
                Label("Unable to Load Qualifying Results", systemImage: "exclamationmark.triangle")
            } description: {
                Text(error)
            } actions: {
                Button("Retry") { Task { await loadInitialPage() } }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List {
                ForEach(state.items, id: \.id) { result in
                    F1UI.Qualifying.Row(result)
                        .onAppear {
                            Task { await loadMoreIfNeeded(afterAppearing: result.id) }
                        }
                }

                if state.isLoadingMore {
                    HStack { Spacer(); ProgressView(); Spacer() }
                } else if let error = state.error {
                    footerRetryView(error: error)
                }
            }
            .animation(F1Theme.Motion.easeInOutStandard, value: state.isLoadingMore)
            .animation(F1Theme.Motion.easeInOutStandard, value: state.error)
        }
    }

    private var shouldLoadInitialPage: Bool {
        state.items.isEmpty && !state.isLoadingInitial && state.error == nil
    }

    private func footerRetryView(error: String) -> some View {
        VStack(spacing: 8) {
            Text(error)
                .font(F1Theme.Typography.meta)
                .foregroundStyle(F1Theme.Colors.textSecondary)
            Button("Retry") { Task { await loadNextPage() } }
        }
        .frame(maxWidth: .infinity)
    }

    @MainActor
    private func loadInitialPage() async {
        guard let request = makePageRequest(offset: 0) else { state = Self.makeInitialErrorState(); return }
        state = .loadingInitial
        do {
            let page = try await getQualifyingResultsPage(seasonId, round, request)
            state = Self.makeLoadedState(from: page)
        } catch {
            state = Self.makeInitialErrorState(from: error)
        }
    }

    @MainActor
    private func loadMoreIfNeeded(afterAppearing resultId: String) async {
        guard resultId == state.items.last?.id else { return }
        guard state.hasMore, !state.isLoadingInitial, !state.isLoadingMore else { return }
        await loadNextPage()
    }

    @MainActor
    private func loadNextPage() async {
        guard state.hasMore, !state.isLoadingInitial, !state.isLoadingMore else { return }
        guard let request = makePageRequest(offset: state.nextOffset) else { state = Self.makeLoadMoreErrorState(from: state); return }

        let currentItems = state.items
        state = Self.makeLoadingMoreState(from: state)
        do {
            let page = try await getQualifyingResultsPage(seasonId, round, request)
            state = Self.makeLoadedState(from: page, existingItems: currentItems)
        } catch {
            state = Self.makeLoadMoreErrorState(from: state, error: error)
        }
    }

    private func makePageRequest(offset: Int) -> PageRequest? {
        try? PageRequest(limit: pageLimit, offset: offset)
    }

    static func makeLoadedState(
        from page: Page<QualifyingResult>,
        existingItems: [F1UI.Qualifying.Row.ViewData] = []
    ) -> ViewState {
        .init(
            items: mergeUniqueByID(existingItems, with: page.items.map(Self.makeRowData), id: \.id),
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: page.hasMore,
            nextOffset: page.offset + page.limit,
            error: nil
        )
    }

    static func makeInitialErrorState(from error: (any Error)? = nil) -> ViewState {
        .init(items: [], isLoadingInitial: false, isLoadingMore: false, hasMore: true, nextOffset: 0, error: "Failed to load qualifying results. Please try again.")
    }

    static func makeLoadingMoreState(from state: ViewState) -> ViewState {
        .init(items: state.items, isLoadingInitial: false, isLoadingMore: true, hasMore: state.hasMore, nextOffset: state.nextOffset, error: nil)
    }

    static func makeLoadMoreErrorState(from state: ViewState, error: (any Error)? = nil) -> ViewState {
        .init(items: state.items, isLoadingInitial: false, isLoadingMore: false, hasMore: state.hasMore, nextOffset: state.nextOffset, error: "Failed to load qualifying results. Please try again.")
    }

    static func makeRowData(from result: QualifyingResult) -> F1UI.Qualifying.Row.ViewData {
        .init(
            id: "\(result.seasonId.rawValue)-\(result.round.rawValue)-\(result.driver.id.rawValue)",
            positionText: result.position.map(String.init) ?? "-",
            driverName: "\(result.driver.givenName) \(result.driver.familyName)",
            constructorName: result.constructor.name,
            q1Text: result.q1?.rawValue,
            q2Text: result.q2?.rawValue,
            q3Text: result.q3?.rawValue
        )
    }
}

extension QualifyingResultsScreen {
    typealias ViewState = PagedListState<F1UI.Qualifying.Row.ViewData>
}

#Preview("Qualifying Results Loading") {
    NavigationStack {
        QualifyingResultsScreen(seasonId: .init(rawValue: "2024"), round: .init(rawValue: "1"), previewState: .loadingInitial)
    }
}

#Preview("Qualifying Results Error") {
    NavigationStack {
        QualifyingResultsScreen(seasonId: .init(rawValue: "2024"), round: .init(rawValue: "1"), previewState: QualifyingResultsScreen.makeInitialErrorState())
    }
}

#Preview("Qualifying Results Loaded") {
    NavigationStack {
        QualifyingResultsScreen(
            seasonId: .init(rawValue: "2024"),
            round: .init(rawValue: "1"),
            previewState: .init(
                items: [
                    .init(id: "2024-1-max_verstappen", positionText: "1", driverName: "Max Verstappen", constructorName: "Red Bull Racing", q1Text: "1:29.421", q2Text: "1:29.374", q3Text: "1:29.179"),
                    .init(id: "2024-1-charles_leclerc", positionText: "2", driverName: "Charles Leclerc", constructorName: "Ferrari", q1Text: "1:29.500", q2Text: "1:29.401", q3Text: "1:29.407")
                ],
                isLoadingInitial: false,
                isLoadingMore: false,
                hasMore: true,
                nextOffset: 30,
                error: nil
            )
        )
    }
}

#Preview("Qualifying Results Loading More") {
    NavigationStack {
        QualifyingResultsScreen(
            seasonId: .init(rawValue: "2024"),
            round: .init(rawValue: "1"),
            previewState: .init(
                items: [
                    .init(id: "2024-1-max_verstappen", positionText: "1", driverName: "Max Verstappen", constructorName: "Red Bull Racing", q1Text: "1:29.421", q2Text: "1:29.374", q3Text: "1:29.179"),
                    .init(id: "2024-1-charles_leclerc", positionText: "2", driverName: "Charles Leclerc", constructorName: "Ferrari", q1Text: "1:29.500", q2Text: "1:29.401", q3Text: "1:29.407")
                ],
                isLoadingInitial: false,
                isLoadingMore: true,
                hasMore: true,
                nextOffset: 30,
                error: nil
            )
        )
    }
}

#Preview("Qualifying Results Load More Error") {
    NavigationStack {
        QualifyingResultsScreen(
            seasonId: .init(rawValue: "2024"),
            round: .init(rawValue: "1"),
            previewState: .init(
                items: [
                    .init(id: "2024-1-max_verstappen", positionText: "1", driverName: "Max Verstappen", constructorName: "Red Bull Racing", q1Text: "1:29.421", q2Text: "1:29.374", q3Text: "1:29.179"),
                    .init(id: "2024-1-charles_leclerc", positionText: "2", driverName: "Charles Leclerc", constructorName: "Ferrari", q1Text: "1:29.500", q2Text: "1:29.401", q3Text: "1:29.407")
                ],
                isLoadingInitial: false,
                isLoadingMore: false,
                hasMore: true,
                nextOffset: 30,
                error: "Failed to load qualifying results. Please try again."
            )
        )
    }
}
