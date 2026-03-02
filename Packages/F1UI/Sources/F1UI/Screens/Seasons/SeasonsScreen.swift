import F1Domain
import F1UseCases
import SwiftUI

public struct SeasonsScreen: View {
    @State private var state: ViewState

    private let getSeasonsPage: @Sendable (PageRequest) async throws -> Page<Season>
    private let getRaces: @Sendable (Season.ID) async throws -> [Race]
    private let pageLimit: Int

    public init(
        getSeasonsPageUseCase: GetSeasonsPageUseCase,
        getRacesForSeasonUseCase: GetRacesForSeasonUseCase,
        pageLimit: Int = 30
    ) {
        self.getSeasonsPage = { request in
            try await getSeasonsPageUseCase(request: request)
        }
        self.getRaces = { seasonId in
            try await getRacesForSeasonUseCase(seasonId: seasonId)
        }
        self.pageLimit = pageLimit
        self._state = State(initialValue: .initial)
    }

    init(
        getSeasonsPage: @escaping @Sendable (PageRequest) async throws -> Page<Season>,
        getRaces: @escaping @Sendable (Season.ID) async throws -> [Race],
        pageLimit: Int = 30
    ) {
        self.getSeasonsPage = getSeasonsPage
        self.getRaces = getRaces
        self.pageLimit = pageLimit
        self._state = State(initialValue: .initial)
    }

    init(previewState state: ViewState) {
        self.getSeasonsPage = { request in
            try Page(
                items: [],
                total: 0,
                limit: request.limit,
                offset: request.offset
            )
        }
        self.getRaces = { _ in [] }
        self.pageLimit = 30
        self._state = State(initialValue: state)
    }

    public var body: some View {
        NavigationStack {
            content
                .navigationTitle("Seasons")
        }
        .task {
            if shouldLoadInitialPage {
                await loadInitialPage()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if state.isLoadingInitial {
            ProgressView("Loading seasons...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if state.items.isEmpty, let error = state.error {
            ContentUnavailableView {
                Label("Unable to Load Seasons", systemImage: "exclamationmark.triangle")
            } description: {
                Text(error)
            } actions: {
                Button("Retry") {
                    Task {
                        await loadInitialPage()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List {
                ForEach(state.items, id: \.id) { season in
                    NavigationLink {
                        RacesScreen(seasonId: Season.ID(rawValue: season.id), getRaces: getRaces)
                    } label: {
                        F1UI.Season.Row(season)
                    }
                    .onAppear {
                        Task {
                            await loadMoreIfNeeded(afterAppearing: season.id)
                        }
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
        Self.shouldLoadInitialPage(state: state)
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
                Task {
                    await loadNextPage()
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    @MainActor
    private func loadInitialPage() async {
        state = await Self.loadInitialPageState(
            pageLimit: pageLimit,
            getSeasonsPage: getSeasonsPage
        )
    }

    @MainActor
    private func loadMoreIfNeeded(afterAppearing seasonId: String) async {
        guard Self.shouldLoadMore(afterAppearing: seasonId, state: state) else { return }

        await loadNextPage()
    }

    @MainActor
    private func loadNextPage() async {
        state = await Self.loadNextPageState(
            from: state,
            pageLimit: pageLimit,
            getSeasonsPage: getSeasonsPage
        )
    }

    static func makeLoadedState(
        from page: Page<Season>,
        existingItems: [F1UI.Season.Row.ViewData] = []
    ) -> ViewState {
        ViewState(
            items: merge(existingItems, with: page.items.map(Self.makeRowData)),
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: page.hasMore,
            nextOffset: page.offset + page.limit,
            error: nil
        )
    }

    static func makeInitialErrorState(from error: (any Error)? = nil) -> ViewState {
        ViewState(
            items: [],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 0,
            error: "Failed to load seasons. Please try again."
        )
    }

    static func makeLoadingMoreState(from state: ViewState) -> ViewState {
        ViewState(
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
        ViewState(
            items: state.items,
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: state.hasMore,
            nextOffset: state.nextOffset,
            error: "Failed to load seasons. Please try again."
        )
    }

    static func makeRowData(from season: Season) -> F1UI.Season.Row.ViewData {
        .init(
            id: season.id.rawValue,
            title: season.id.rawValue,
            showsWikipediaIndicator: season.wikipediaURL != nil
        )
    }

    private static func merge(
        _ existingItems: [F1UI.Season.Row.ViewData],
        with newItems: [F1UI.Season.Row.ViewData]
    ) -> [F1UI.Season.Row.ViewData] {
        var mergedItems = existingItems

        for item in newItems where !mergedItems.contains(where: { $0.id == item.id }) {
            mergedItems.append(item)
        }

        return mergedItems
    }

    static func shouldLoadInitialPage(state: ViewState) -> Bool {
        state.items.isEmpty && !state.isLoadingInitial && state.error == nil
    }

    static func shouldLoadMore(afterAppearing seasonId: String, state: ViewState) -> Bool {
        seasonId == state.items.last?.id && state.hasMore && !state.isLoadingInitial && !state.isLoadingMore
    }

    static func loadInitialPageState(
        pageLimit: Int,
        getSeasonsPage: @Sendable (PageRequest) async throws -> Page<Season>
    ) async -> ViewState {
        guard let request = makePageRequest(limit: pageLimit, offset: 0) else {
            return makeInitialErrorState()
        }

        do {
            let page = try await getSeasonsPage(request)
            return makeLoadedState(from: page)
        } catch {
            return makeInitialErrorState(from: error)
        }
    }

    static func loadNextPageState(
        from state: ViewState,
        pageLimit: Int,
        getSeasonsPage: @Sendable (PageRequest) async throws -> Page<Season>
    ) async -> ViewState {
        guard state.hasMore, !state.isLoadingInitial, !state.isLoadingMore else {
            return state
        }

        guard let request = makePageRequest(limit: pageLimit, offset: state.nextOffset) else {
            return makeLoadMoreErrorState(from: state)
        }

        do {
            let page = try await getSeasonsPage(request)
            return makeLoadedState(from: page, existingItems: state.items)
        } catch {
            return makeLoadMoreErrorState(from: state, error: error)
        }
    }

    private static func makePageRequest(limit: Int, offset: Int) -> PageRequest? {
        try? PageRequest(limit: limit, offset: offset)
    }
}

extension SeasonsScreen {
    struct ViewState: Equatable {
        let items: [F1UI.Season.Row.ViewData]
        let isLoadingInitial: Bool
        let isLoadingMore: Bool
        let hasMore: Bool
        let nextOffset: Int
        let error: String?

        static let initial = ViewState(
            items: [],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 0,
            error: nil
        )

        static let loadingInitial = ViewState(
            items: [],
            isLoadingInitial: true,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 0,
            error: nil
        )
    }
}

#Preview("Loading") {
    SeasonsScreen(previewState: .loadingInitial)
}

#Preview("Error") {
    SeasonsScreen(previewState: SeasonsScreen.makeInitialErrorState())
}

#Preview("Loaded First Page") {
    SeasonsScreen(
        previewState: .init(
            items: [
                .init(id: "2024", title: "2024", showsWikipediaIndicator: true),
                .init(id: "2023", title: "2023", showsWikipediaIndicator: false),
                .init(id: "2022", title: "2022", showsWikipediaIndicator: true)
            ],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: false,
            nextOffset: 3,
            error: nil
        )
    )
}

#Preview("Loaded With More") {
    SeasonsScreen(
        previewState: .init(
            items: [
                .init(id: "2024", title: "2024", showsWikipediaIndicator: true),
                .init(id: "2023", title: "2023", showsWikipediaIndicator: false),
                .init(id: "2022", title: "2022", showsWikipediaIndicator: true)
            ],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 30,
            error: nil
        )
    )
}

#Preview("Loading More Footer") {
    SeasonsScreen(
        previewState: .init(
            items: [
                .init(id: "2024", title: "2024", showsWikipediaIndicator: true),
                .init(id: "2023", title: "2023", showsWikipediaIndicator: false)
            ],
            isLoadingInitial: false,
            isLoadingMore: true,
            hasMore: true,
            nextOffset: 30,
            error: nil
        )
    )
}

#Preview("Load More Error Footer") {
    SeasonsScreen(
        previewState: .init(
            items: [
                .init(id: "2024", title: "2024", showsWikipediaIndicator: true),
                .init(id: "2023", title: "2023", showsWikipediaIndicator: false)
            ],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 30,
            error: "Failed to load seasons. Please try again."
        )
    )
}
