import F1Domain
import F1UseCases
import SwiftUI

public struct DriverStandingsScreen: View {
    @State private var state: ViewState

    private let seasonId: Season.ID
    private let getDriverStandingsPage: @Sendable (Season.ID, PageRequest) async throws -> Page<DriverStanding>
    private let pageLimit: Int

    public init(
        seasonId: Season.ID,
        getDriverStandingsPageUseCase: GetDriverStandingsPageUseCase,
        pageLimit: Int = 30
    ) {
        self.seasonId = seasonId
        self.getDriverStandingsPage = { seasonId, request in
            try await getDriverStandingsPageUseCase(seasonId: seasonId, request: request)
        }
        self.pageLimit = pageLimit
        self._state = State(initialValue: .initial)
    }

    init(
        seasonId: Season.ID,
        getDriverStandingsPage: @escaping @Sendable (Season.ID, PageRequest) async throws -> Page<DriverStanding>,
        pageLimit: Int = 30
    ) {
        self.seasonId = seasonId
        self.getDriverStandingsPage = getDriverStandingsPage
        self.pageLimit = pageLimit
        self._state = State(initialValue: .initial)
    }

    init(seasonId: Season.ID, previewState: ViewState) {
        self.seasonId = seasonId
        self.getDriverStandingsPage = { seasonId, request in
            _ = seasonId
            return try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.pageLimit = 30
        self._state = State(initialValue: previewState)
    }

    public var body: some View {
        content
            .navigationTitle("\(seasonId.rawValue) Driver Standings")
            .task {
                if shouldLoadInitialPage {
                    await loadInitialPage()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if state.isLoadingInitial {
            ProgressView("Loading driver standings...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if state.items.isEmpty, let error = state.error {
            ContentUnavailableView {
                Label("Unable to Load Driver Standings", systemImage: "exclamationmark.triangle")
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
            let page = try await getDriverStandingsPage(seasonId, request)
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
            let page = try await getDriverStandingsPage(seasonId, request)
            state = Self.makeLoadedState(from: page, existingItems: currentItems)
        } catch {
            state = Self.makeLoadMoreErrorState(from: state, error: error)
        }
    }

    private func makePageRequest(offset: Int) -> PageRequest? {
        try? PageRequest(limit: pageLimit, offset: offset)
    }

    static func makeLoadedState(
        from page: Page<DriverStanding>,
        existingItems: [F1UI.Standing.Row.ViewData] = []
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
        .init(items: [], isLoadingInitial: false, isLoadingMore: false, hasMore: true, nextOffset: 0, error: "Failed to load driver standings. Please try again.")
    }

    static func makeLoadingMoreState(from state: ViewState) -> ViewState {
        .init(items: state.items, isLoadingInitial: false, isLoadingMore: true, hasMore: state.hasMore, nextOffset: state.nextOffset, error: nil)
    }

    static func makeLoadMoreErrorState(from state: ViewState, error: (any Error)? = nil) -> ViewState {
        .init(items: state.items, isLoadingInitial: false, isLoadingMore: false, hasMore: state.hasMore, nextOffset: state.nextOffset, error: "Failed to load driver standings. Please try again.")
    }

    static func makeRowData(from standing: DriverStanding) -> F1UI.Standing.Row.ViewData {
        .init(
            id: "\(standing.seasonId.rawValue)-\(standing.driver.id.rawValue)",
            positionText: standing.position.map(String.init) ?? "-",
            title: "\(standing.driver.givenName) \(standing.driver.familyName)",
            subtitle: standing.constructors.map(\.name).joined(separator: ", "),
            pointsText: "\(formatPoints(standing.points)) pts",
            winsText: "\(standing.wins) wins"
        )
    }

    private static func formatPoints(_ points: Double) -> String {
        if points.rounded() == points {
            return String(Int(points))
        }
        return String(points)
    }
}

extension DriverStandingsScreen {
    typealias ViewState = PagedListState<F1UI.Standing.Row.ViewData>
}

#Preview("Driver Standings Loading") {
    NavigationStack {
        DriverStandingsScreen(seasonId: .init(rawValue: "2024"), previewState: .loadingInitial)
    }
}

#Preview("Driver Standings Error") {
    NavigationStack {
        DriverStandingsScreen(seasonId: .init(rawValue: "2024"), previewState: DriverStandingsScreen.makeInitialErrorState())
    }
}

#Preview("Driver Standings Loaded") {
    NavigationStack {
        DriverStandingsScreen(
            seasonId: .init(rawValue: "2024"),
            previewState: .init(
                items: [
                    .init(id: "2024-max_verstappen", positionText: "1", title: "Max Verstappen", subtitle: "Red Bull Racing", pointsText: "575 pts", winsText: "9 wins"),
                    .init(id: "2024-lando_norris", positionText: "2", title: "Lando Norris", subtitle: "McLaren", pointsText: "374 pts", winsText: "3 wins")
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
