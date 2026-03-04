import F1Domain
import F1UseCases
import SwiftUI

public struct ConstructorStandingsScreen: View {
    @State private var state: ViewState

    private let seasonId: Season.ID
    private let getConstructorStandingsPage: @Sendable (Season.ID, PageRequest) async throws -> Page<ConstructorStanding>
    private let pageLimit: Int

    public init(
        seasonId: Season.ID,
        getConstructorStandingsPageUseCase: GetConstructorStandingsPageUseCase,
        pageLimit: Int = 30
    ) {
        self.seasonId = seasonId
        self.getConstructorStandingsPage = { seasonId, request in
            try await getConstructorStandingsPageUseCase(seasonId: seasonId, request: request)
        }
        self.pageLimit = pageLimit
        self._state = State(initialValue: .initial)
    }

    init(
        seasonId: Season.ID,
        getConstructorStandingsPage: @escaping @Sendable (Season.ID, PageRequest) async throws -> Page<ConstructorStanding>,
        pageLimit: Int = 30
    ) {
        self.seasonId = seasonId
        self.getConstructorStandingsPage = getConstructorStandingsPage
        self.pageLimit = pageLimit
        self._state = State(initialValue: .initial)
    }

    init(seasonId: Season.ID, previewState: ViewState) {
        self.seasonId = seasonId
        self.getConstructorStandingsPage = { seasonId, request in
            _ = seasonId
            return try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.pageLimit = 30
        self._state = State(initialValue: previewState)
    }

    public var body: some View {
        content
            .navigationTitle("\(seasonId.rawValue) Constructor Standings")
            .task {
                if shouldLoadInitialPage {
                    await loadInitialPage()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if state.isLoadingInitial {
            ProgressView("Loading constructor standings...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if state.items.isEmpty, let error = state.error {
            ContentUnavailableView {
                Label("Unable to Load Constructor Standings", systemImage: "exclamationmark.triangle")
            } description: {
                Text(error)
            } actions: {
                Button("Retry") { Task { await loadInitialPage() } }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List {
                ForEach(state.items, id: \.id) { standing in
                    F1UI.Standing.Row(standing)
                        .onAppear {
                            Task { await loadMoreIfNeeded(afterAppearing: standing.id) }
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
            let page = try await getConstructorStandingsPage(seasonId, request)
            state = Self.makeLoadedState(from: page)
        } catch {
            state = Self.makeInitialErrorState(from: error)
        }
    }

    @MainActor
    private func loadMoreIfNeeded(afterAppearing standingId: String) async {
        guard standingId == state.items.last?.id else { return }
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
            let page = try await getConstructorStandingsPage(seasonId, request)
            state = Self.makeLoadedState(from: page, existingItems: currentItems)
        } catch {
            state = Self.makeLoadMoreErrorState(from: state, error: error)
        }
    }

    private func makePageRequest(offset: Int) -> PageRequest? {
        try? PageRequest(limit: pageLimit, offset: offset)
    }

    static func makeLoadedState(
        from page: Page<ConstructorStanding>,
        existingItems: [F1UI.Standing.Row.ViewData] = []
    ) -> ViewState {
        let existingMaxPoints: Double = existingItems.compactMap { $0.pointsValue }.max() ?? 0
        let pageMaxPoints: Double = page.items.map { $0.points }.max() ?? 0
        let maxPointsValue = max(existingMaxPoints, pageMaxPoints)

        return .init(
            items: mergeUniqueByID(
                existingItems,
                with: page.items.map { Self.makeRowData(from: $0, maxPointsValue: maxPointsValue) },
                id: \.id
            ),
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: page.hasMore,
            nextOffset: page.offset + page.limit,
            error: nil
        )
    }

    static func makeInitialErrorState(from error: (any Error)? = nil) -> ViewState {
        .init(items: [], isLoadingInitial: false, isLoadingMore: false, hasMore: true, nextOffset: 0, error: "Failed to load constructor standings. Please try again.")
    }

    static func makeLoadingMoreState(from state: ViewState) -> ViewState {
        .init(items: state.items, isLoadingInitial: false, isLoadingMore: true, hasMore: state.hasMore, nextOffset: state.nextOffset, error: nil)
    }

    static func makeLoadMoreErrorState(from state: ViewState, error: (any Error)? = nil) -> ViewState {
        .init(items: state.items, isLoadingInitial: false, isLoadingMore: false, hasMore: state.hasMore, nextOffset: state.nextOffset, error: "Failed to load constructor standings. Please try again.")
    }

    static func makeRowData(
        from standing: ConstructorStanding,
        maxPointsValue: Double
    ) -> F1UI.Standing.Row.ViewData {
        .init(
            id: "\(standing.seasonId.rawValue)-\(standing.constructor.id.rawValue)",
            positionText: standing.position.map(String.init) ?? "-",
            title: standing.constructor.name,
            subtitle: standing.constructor.nationality,
            pointsText: "\(formatPoints(standing.points)) pts",
            winsText: "\(standing.wins) wins",
            position: standing.position,
            pointsValue: standing.points,
            maxPointsValue: maxPointsValue,
            winsCount: standing.wins
        )
    }

    private static func formatPoints(_ points: Double) -> String {
        if points.rounded() == points {
            return String(Int(points))
        }
        return String(points)
    }
}

extension ConstructorStandingsScreen {
    typealias ViewState = PagedListState<F1UI.Standing.Row.ViewData>
}

#Preview("Constructor Standings Loading") {
    NavigationStack {
        ConstructorStandingsScreen(seasonId: .init(rawValue: "2024"), previewState: .loadingInitial)
    }
}

#Preview("Constructor Standings Error") {
    NavigationStack {
        ConstructorStandingsScreen(seasonId: .init(rawValue: "2024"), previewState: ConstructorStandingsScreen.makeInitialErrorState())
    }
}

#Preview("Constructor Standings Loaded") {
    NavigationStack {
        ConstructorStandingsScreen(
            seasonId: .init(rawValue: "2024"),
            previewState: .init(
                items: [
                    .init(id: "2024-mclaren", positionText: "1", title: "McLaren", subtitle: "British", pointsText: "666 pts", winsText: "6 wins", position: 1, pointsValue: 666, maxPointsValue: 666, winsCount: 6),
                    .init(id: "2024-ferrari", positionText: "2", title: "Ferrari", subtitle: "Italian", pointsText: "652 pts", winsText: "5 wins", position: 2, pointsValue: 652, maxPointsValue: 666, winsCount: 5)
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

#Preview("Constructor Standings Loading More") {
    NavigationStack {
        ConstructorStandingsScreen(
            seasonId: .init(rawValue: "2024"),
            previewState: .init(
                items: [
                    .init(id: "2024-mclaren", positionText: "1", title: "McLaren", subtitle: "British", pointsText: "666 pts", winsText: "6 wins", position: 1, pointsValue: 666, maxPointsValue: 666, winsCount: 6),
                    .init(id: "2024-ferrari", positionText: "2", title: "Ferrari", subtitle: "Italian", pointsText: "652 pts", winsText: "5 wins", position: 2, pointsValue: 652, maxPointsValue: 666, winsCount: 5)
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

#Preview("Constructor Standings Load More Error") {
    NavigationStack {
        ConstructorStandingsScreen(
            seasonId: .init(rawValue: "2024"),
            previewState: .init(
                items: [
                    .init(id: "2024-mclaren", positionText: "1", title: "McLaren", subtitle: "British", pointsText: "666 pts", winsText: "6 wins"),
                    .init(id: "2024-ferrari", positionText: "2", title: "Ferrari", subtitle: "Italian", pointsText: "652 pts", winsText: "5 wins")
                ],
                isLoadingInitial: false,
                isLoadingMore: false,
                hasMore: true,
                nextOffset: 30,
                error: "Failed to load constructor standings. Please try again."
            )
        )
    }
}
