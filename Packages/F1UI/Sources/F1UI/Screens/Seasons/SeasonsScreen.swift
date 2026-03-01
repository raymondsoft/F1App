import F1Domain
import F1UseCases
import SwiftUI

public struct SeasonsScreen: View {
    @State private var state: ViewState

    private let getSeasonsPage: @Sendable (PageRequest) async throws -> Page<Season>
    private let getRaces: @Sendable (String) async throws -> [Race]
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
            try await getRacesForSeasonUseCase(seasonId: Season.ID(rawValue: seasonId))
        }
        self.pageLimit = pageLimit
        self._state = State(initialValue: .initial)
    }

    public init(
        getSeasonsUseCase: GetSeasonsUseCase,
        getRacesForSeasonUseCase: GetRacesForSeasonUseCase,
        pageLimit: Int = 30
    ) {
        self.getSeasonsPage = { request in
            let seasons = try await getSeasonsUseCase()
            let startIndex = min(request.offset, seasons.count)
            let endIndex = min(startIndex + request.limit, seasons.count)

            return try Page(
                items: Array(seasons[startIndex..<endIndex]),
                total: seasons.count,
                limit: request.limit,
                offset: request.offset
            )
        }
        self.getRaces = { seasonId in
            try await getRacesForSeasonUseCase(seasonId: Season.ID(rawValue: seasonId))
        }
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
                        RacesScreen(seasonId: season.id, getRaces: getRaces)
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
                Task {
                    await loadNextPage()
                }
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
            let page = try await getSeasonsPage(request)
            state = Self.makeLoadedState(from: page)
        } catch {
            state = Self.makeInitialErrorState(from: error)
        }
    }

    @MainActor
    private func loadMoreIfNeeded(afterAppearing seasonId: String) async {
        guard seasonId == state.items.last?.id else {
            return
        }

        guard state.hasMore, !state.isLoadingInitial, !state.isLoadingMore else {
            return
        }

        await loadNextPage()
    }

    @MainActor
    private func loadNextPage() async {
        guard state.hasMore, !state.isLoadingInitial, !state.isLoadingMore else {
            return
        }

        guard let request = makePageRequest(offset: state.nextOffset) else {
            state = Self.makeLoadMoreErrorState(from: state)
            return
        }

        let currentItems = state.items
        state = Self.makeLoadingMoreState(from: state)

        do {
            let page = try await getSeasonsPage(request)
            state = Self.makeLoadedState(from: page, existingItems: currentItems)
        } catch {
            state = Self.makeLoadMoreErrorState(from: state, error: error)
        }
    }

    private func makePageRequest(offset: Int) -> PageRequest? {
        try? PageRequest(limit: pageLimit, offset: offset)
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
