import F1Domain
import F1UseCases
import SwiftUI

public struct RaceResultsScreen: View {
    @State private var state: ViewState

    private let seasonId: Season.ID
    private let round: Race.Round
    private let getRaceResultsPage: @Sendable (Season.ID, Race.Round, PageRequest) async throws -> Page<RaceResult>
    private let pageLimit: Int

    public init(
        seasonId: Season.ID,
        round: Race.Round,
        getRaceResultsPageUseCase: GetRaceResultsPageUseCase,
        pageLimit: Int = 30
    ) {
        self.seasonId = seasonId
        self.round = round
        self.getRaceResultsPage = { seasonId, round, request in
            try await getRaceResultsPageUseCase(seasonId: seasonId, round: round, request: request)
        }
        self.pageLimit = pageLimit
        self._state = State(initialValue: .initial)
    }

    init(
        seasonId: Season.ID,
        round: Race.Round,
        getRaceResultsPage: @escaping @Sendable (Season.ID, Race.Round, PageRequest) async throws -> Page<RaceResult>,
        pageLimit: Int = 30
    ) {
        self.seasonId = seasonId
        self.round = round
        self.getRaceResultsPage = getRaceResultsPage
        self.pageLimit = pageLimit
        self._state = State(initialValue: .initial)
    }

    init(seasonId: Season.ID, round: Race.Round, previewState: ViewState) {
        self.seasonId = seasonId
        self.round = round
        self.getRaceResultsPage = { seasonId, round, request in
            _ = seasonId
            _ = round
            return try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.pageLimit = 30
        self._state = State(initialValue: previewState)
    }

    public var body: some View {
        content
            .navigationTitle("\(seasonId.rawValue) R\(round.rawValue) Results")
            .task {
                if shouldLoadInitialPage {
                    await loadInitialPage()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if state.isLoadingInitial {
            ProgressView("Loading race results...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if state.items.isEmpty, let error = state.error {
            ContentUnavailableView {
                Label("Unable to Load Results", systemImage: "exclamationmark.triangle")
            } description: {
                Text(error)
            } actions: {
                Button("Retry") { Task { await loadInitialPage() } }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List {
                ForEach(state.items, id: \.id) { result in
                    F1UI.Result.Row(result)
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
        }
    }

    private var shouldLoadInitialPage: Bool {
        state.items.isEmpty && !state.isLoadingInitial && state.error == nil
    }

    private func footerRetryView(error: String) -> some View {
        VStack(spacing: 8) {
            Text(error).font(.footnote).foregroundStyle(.secondary)
            Button("Retry") { Task { await loadNextPage() } }
        }
        .frame(maxWidth: .infinity)
    }

    @MainActor
    private func loadInitialPage() async {
        guard let request = makePageRequest(offset: 0) else { state = Self.makeInitialErrorState(); return }
        state = .loadingInitial
        do {
            let page = try await getRaceResultsPage(seasonId, round, request)
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
            let page = try await getRaceResultsPage(seasonId, round, request)
            state = Self.makeLoadedState(from: page, existingItems: currentItems)
        } catch {
            state = Self.makeLoadMoreErrorState(from: state, error: error)
        }
    }

    private func makePageRequest(offset: Int) -> PageRequest? {
        try? PageRequest(limit: pageLimit, offset: offset)
    }

    static func makeLoadedState(
        from page: Page<RaceResult>,
        existingItems: [F1UI.Result.Row.ViewData] = []
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
        .init(items: [], isLoadingInitial: false, isLoadingMore: false, hasMore: true, nextOffset: 0, error: "Failed to load race results. Please try again.")
    }

    static func makeLoadingMoreState(from state: ViewState) -> ViewState {
        .init(items: state.items, isLoadingInitial: false, isLoadingMore: true, hasMore: state.hasMore, nextOffset: state.nextOffset, error: nil)
    }

    static func makeLoadMoreErrorState(from state: ViewState, error: (any Error)? = nil) -> ViewState {
        .init(items: state.items, isLoadingInitial: false, isLoadingMore: false, hasMore: state.hasMore, nextOffset: state.nextOffset, error: "Failed to load race results. Please try again.")
    }

    static func makeRowData(from result: RaceResult) -> F1UI.Result.Row.ViewData {
        .init(
            id: "\(result.seasonId.rawValue)-\(result.round.rawValue)-\(result.driver.id.rawValue)",
            positionText: result.positionText,
            driverName: "\(result.driver.givenName) \(result.driver.familyName)",
            constructorName: result.constructor.name,
            pointsText: "\(formatPoints(result.points)) pts",
            resultText: makeResultText(from: result)
        )
    }

    private static func makeResultText(from result: RaceResult) -> String {
        if let resultTime = result.resultTime {
            switch resultTime {
            case .time(let value), .status(let value):
                return value
            }
        }

        return result.status
    }

    private static func formatPoints(_ points: Double) -> String {
        if points.rounded() == points {
            return String(Int(points))
        }

        return String(points)
    }
}

extension RaceResultsScreen {
    typealias ViewState = PagedListState<F1UI.Result.Row.ViewData>
}

#Preview("Race Results Loading") {
    NavigationStack {
        RaceResultsScreen(seasonId: .init(rawValue: "2024"), round: .init(rawValue: "1"), previewState: .loadingInitial)
    }
}

#Preview("Race Results Error") {
    NavigationStack {
        RaceResultsScreen(seasonId: .init(rawValue: "2024"), round: .init(rawValue: "1"), previewState: RaceResultsScreen.makeInitialErrorState())
    }
}

#Preview("Race Results Loaded") {
    NavigationStack {
        RaceResultsScreen(
            seasonId: .init(rawValue: "2024"),
            round: .init(rawValue: "1"),
            previewState: .init(
                items: [
                    .init(id: "2024-1-max_verstappen", positionText: "1", driverName: "Max Verstappen", constructorName: "Red Bull Racing", pointsText: "25 pts", resultText: "1:31:44.742"),
                    .init(id: "2024-1-sergio_perez", positionText: "2", driverName: "Sergio Perez", constructorName: "Red Bull Racing", pointsText: "18 pts", resultText: "+22.457s")
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
