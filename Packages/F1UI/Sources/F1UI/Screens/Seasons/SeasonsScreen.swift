import F1Domain
import F1UseCases
import SwiftUI

public struct SeasonsScreen: View {
    @State private var state: ViewState

    private let getSeasonsPage: @Sendable (PageRequest) async throws -> Page<Season>
    private let getRaces: @Sendable (Season.ID) async throws -> [Race]
    private let getDriversPage: @Sendable (Season.ID, PageRequest) async throws -> Page<Driver>
    private let getConstructorsPage: @Sendable (Season.ID, PageRequest) async throws -> Page<Constructor>
    private let getRaceResultsPage: @Sendable (Season.ID, Race.Round, PageRequest) async throws -> Page<RaceResult>
    private let getQualifyingResultsPage: @Sendable (Season.ID, Race.Round, PageRequest) async throws -> Page<QualifyingResult>
    private let getDriverStandingsPage: @Sendable (Season.ID, PageRequest) async throws -> Page<DriverStanding>
    private let getConstructorStandingsPage: @Sendable (Season.ID, PageRequest) async throws -> Page<ConstructorStanding>
    private let pageLimit: Int

    public init(
        getSeasonsPageUseCase: GetSeasonsPageUseCase,
        getDriversPageUseCase: GetDriversPageUseCase,
        getConstructorsPageUseCase: GetConstructorsPageUseCase,
        getRacesForSeasonUseCase: GetRacesForSeasonUseCase,
        getRaceResultsPageUseCase: GetRaceResultsPageUseCase,
        getQualifyingResultsPageUseCase: GetQualifyingResultsPageUseCase,
        getDriverStandingsPageUseCase: GetDriverStandingsPageUseCase,
        getConstructorStandingsPageUseCase: GetConstructorStandingsPageUseCase,
        pageLimit: Int = 30
    ) {
        self.getSeasonsPage = { request in
            try await getSeasonsPageUseCase(request: request)
        }
        self.getRaces = { seasonId in
            try await getRacesForSeasonUseCase(seasonId: seasonId)
        }
        self.getDriversPage = { seasonId, request in
            try await getDriversPageUseCase(seasonId: seasonId, request: request)
        }
        self.getConstructorsPage = { seasonId, request in
            try await getConstructorsPageUseCase(seasonId: seasonId, request: request)
        }
        self.getRaceResultsPage = { seasonId, round, request in
            try await getRaceResultsPageUseCase(seasonId: seasonId, round: round, request: request)
        }
        self.getQualifyingResultsPage = { seasonId, round, request in
            try await getQualifyingResultsPageUseCase(seasonId: seasonId, round: round, request: request)
        }
        self.getDriverStandingsPage = { seasonId, request in
            try await getDriverStandingsPageUseCase(seasonId: seasonId, request: request)
        }
        self.getConstructorStandingsPage = { seasonId, request in
            try await getConstructorStandingsPageUseCase(seasonId: seasonId, request: request)
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
        self.getDriversPage = { _, request in
            try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.getConstructorsPage = { _, request in
            try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.getRaceResultsPage = { _, _, request in
            try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.getQualifyingResultsPage = { _, _, request in
            try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.getDriverStandingsPage = { _, request in
            try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.getConstructorStandingsPage = { _, request in
            try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
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
        self.getDriversPage = { _, request in
            try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.getConstructorsPage = { _, request in
            try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.getRaceResultsPage = { _, _, request in
            try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.getQualifyingResultsPage = { _, _, request in
            try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.getDriverStandingsPage = { _, request in
            try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.getConstructorStandingsPage = { _, request in
            try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
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
                    let seasonId = Season.ID(rawValue: season.id)

                    Section {
                        NavigationLink {
                            RacesScreen(
                                seasonId: seasonId,
                                getRaces: getRaces,
                                getRaceResultsPage: getRaceResultsPage,
                                getQualifyingResultsPage: getQualifyingResultsPage
                            )
                        } label: {
                            F1UI.Season.Row(season)
                        }

                        NavigationLink {
                            DriversScreen(seasonId: seasonId, getDriversPage: getDriversPage)
                        } label: {
                            Label("Drivers", systemImage: "person.2")
                        }

                        NavigationLink {
                            ConstructorsScreen(seasonId: seasonId, getConstructorsPage: getConstructorsPage)
                        } label: {
                            Label("Constructors", systemImage: "wrench.and.screwdriver")
                        }

                        NavigationLink {
                            DriverStandingsScreen(seasonId: seasonId, getDriverStandingsPage: getDriverStandingsPage)
                        } label: {
                            Label("Driver Standings", systemImage: "list.number")
                        }

                        NavigationLink {
                            ConstructorStandingsScreen(
                                seasonId: seasonId,
                                getConstructorStandingsPage: getConstructorStandingsPage
                            )
                        } label: {
                            Label("Constructor Standings", systemImage: "list.number")
                        }
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
