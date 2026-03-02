import F1Domain
import F1UseCases
import SwiftUI

public struct DriversScreen: View {
    @State private var state: ViewState

    private let seasonId: Season.ID
    private let getDriversPage: @Sendable (Season.ID, PageRequest) async throws -> Page<Driver>
    private let pageLimit: Int

    public init(
        seasonId: Season.ID,
        getDriversPageUseCase: GetDriversPageUseCase,
        pageLimit: Int = 30
    ) {
        self.seasonId = seasonId
        self.getDriversPage = { seasonId, request in
            try await getDriversPageUseCase(seasonId: seasonId, request: request)
        }
        self.pageLimit = pageLimit
        self._state = State(initialValue: .initial)
    }

    init(
        seasonId: Season.ID,
        getDriversPage: @escaping @Sendable (Season.ID, PageRequest) async throws -> Page<Driver>,
        pageLimit: Int = 30
    ) {
        self.seasonId = seasonId
        self.getDriversPage = getDriversPage
        self.pageLimit = pageLimit
        self._state = State(initialValue: .initial)
    }

    init(seasonId: Season.ID, previewState: ViewState) {
        self.seasonId = seasonId
        self.getDriversPage = { seasonId, request in
            _ = seasonId
            return try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.pageLimit = 30
        self._state = State(initialValue: previewState)
    }

    public var body: some View {
        content
            .navigationTitle("\(seasonId.rawValue) Drivers")
            .task {
                if shouldLoadInitialPage {
                    await loadInitialPage()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if state.isLoadingInitial {
            ProgressView("Loading drivers...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if state.items.isEmpty, let error = state.error {
            ContentUnavailableView {
                Label("Unable to Load Drivers", systemImage: "exclamationmark.triangle")
            } description: {
                Text(error)
            } actions: {
                Button("Retry") {
                    Task { await loadInitialPage() }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List {
                ForEach(state.items, id: \.id) { driver in
                    F1UI.Driver.Row(driver)
                        .onAppear {
                            Task { await loadMoreIfNeeded(afterAppearing: driver.id) }
                        }
                }

                if state.isLoadingMore {
                    footerProgressView
                } else if let error = state.error {
                    footerRetryView(error: error)
                }
            }
        }
    }

    private var shouldLoadInitialPage: Bool {
        state.items.isEmpty && !state.isLoadingInitial && state.error == nil
    }

    private var footerProgressView: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }

    private func footerRetryView(error: String) -> some View {
        VStack(spacing: 8) {
            Text(error)
                .font(.footnote)
                .foregroundStyle(.secondary)
            Button("Retry") {
                Task { await loadNextPage() }
            }
        }
        .frame(maxWidth: .infinity)
    }

    @MainActor
    private func loadInitialPage() async {
        guard let request = makePageRequest(offset: 0) else {
            state = Self.makeInitialErrorState()
            return
        }

        state = .loadingInitial

        do {
            let page = try await getDriversPage(seasonId, request)
            state = Self.makeLoadedState(from: page)
        } catch {
            state = Self.makeInitialErrorState(from: error)
        }
    }

    @MainActor
    private func loadMoreIfNeeded(afterAppearing driverId: String) async {
        guard driverId == state.items.last?.id else { return }
        guard state.hasMore, !state.isLoadingInitial, !state.isLoadingMore else { return }
        await loadNextPage()
    }

    @MainActor
    private func loadNextPage() async {
        guard state.hasMore, !state.isLoadingInitial, !state.isLoadingMore else { return }
        guard let request = makePageRequest(offset: state.nextOffset) else {
            state = Self.makeLoadMoreErrorState(from: state)
            return
        }

        let currentItems = state.items
        state = Self.makeLoadingMoreState(from: state)

        do {
            let page = try await getDriversPage(seasonId, request)
            state = Self.makeLoadedState(from: page, existingItems: currentItems)
        } catch {
            state = Self.makeLoadMoreErrorState(from: state, error: error)
        }
    }

    private func makePageRequest(offset: Int) -> PageRequest? {
        try? PageRequest(limit: pageLimit, offset: offset)
    }

    static func makeLoadedState(
        from page: Page<Driver>,
        existingItems: [F1UI.Driver.Row.ViewData] = []
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
        .init(
            items: [],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 0,
            error: "Failed to load drivers. Please try again."
        )
    }

    static func makeLoadingMoreState(from state: ViewState) -> ViewState {
        .init(
            items: state.items,
            isLoadingInitial: false,
            isLoadingMore: true,
            hasMore: state.hasMore,
            nextOffset: state.nextOffset,
            error: nil
        )
    }

    static func makeLoadMoreErrorState(
        from state: ViewState,
        error: (any Error)? = nil
    ) -> ViewState {
        .init(
            items: state.items,
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: state.hasMore,
            nextOffset: state.nextOffset,
            error: "Failed to load drivers. Please try again."
        )
    }

    static func makeRowData(from driver: Driver) -> F1UI.Driver.Row.ViewData {
        .init(
            id: driver.id.rawValue,
            name: "\(driver.givenName) \(driver.familyName)",
            nationality: driver.nationality,
            showsWikipediaIndicator: driver.wikipediaURL != nil
        )
    }
}

extension DriversScreen {
    typealias ViewState = PagedListState<F1UI.Driver.Row.ViewData>
}

#Preview("Drivers Loading") {
    NavigationStack {
        DriversScreen(seasonId: .init(rawValue: "2024"), previewState: .loadingInitial)
    }
}

#Preview("Drivers Error") {
    NavigationStack {
        DriversScreen(
            seasonId: .init(rawValue: "2024"),
            previewState: DriversScreen.makeInitialErrorState()
        )
    }
}

#Preview("Drivers Loaded") {
    NavigationStack {
        DriversScreen(
            seasonId: .init(rawValue: "2024"),
            previewState: .init(
                items: [
                    .init(id: "max_verstappen", name: "Max Verstappen", nationality: "Dutch", showsWikipediaIndicator: true),
                    .init(id: "lando_norris", name: "Lando Norris", nationality: "British", showsWikipediaIndicator: true)
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

#Preview("Drivers Loading More") {
    NavigationStack {
        DriversScreen(
            seasonId: .init(rawValue: "2024"),
            previewState: .init(
                items: [
                    .init(id: "max_verstappen", name: "Max Verstappen", nationality: "Dutch", showsWikipediaIndicator: true),
                    .init(id: "lando_norris", name: "Lando Norris", nationality: "British", showsWikipediaIndicator: true)
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

#Preview("Drivers Load More Error") {
    NavigationStack {
        DriversScreen(
            seasonId: .init(rawValue: "2024"),
            previewState: .init(
                items: [
                    .init(id: "max_verstappen", name: "Max Verstappen", nationality: "Dutch", showsWikipediaIndicator: true),
                    .init(id: "lando_norris", name: "Lando Norris", nationality: "British", showsWikipediaIndicator: true)
                ],
                isLoadingInitial: false,
                isLoadingMore: false,
                hasMore: true,
                nextOffset: 30,
                error: "Failed to load drivers. Please try again."
            )
        )
    }
}
