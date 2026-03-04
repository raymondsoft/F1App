import F1Domain
import F1UseCases
import SwiftUI

public struct ConstructorsScreen: View {
    @State private var state: ViewState

    private let seasonId: Season.ID
    private let getConstructorsPage: @Sendable (Season.ID, PageRequest) async throws -> Page<Constructor>
    private let pageLimit: Int

    public init(
        seasonId: Season.ID,
        getConstructorsPageUseCase: GetConstructorsPageUseCase,
        pageLimit: Int = 30
    ) {
        self.seasonId = seasonId
        self.getConstructorsPage = { seasonId, request in
            try await getConstructorsPageUseCase(seasonId: seasonId, request: request)
        }
        self.pageLimit = pageLimit
        self._state = State(initialValue: .initial)
    }

    init(
        seasonId: Season.ID,
        getConstructorsPage: @escaping @Sendable (Season.ID, PageRequest) async throws -> Page<Constructor>,
        pageLimit: Int = 30
    ) {
        self.seasonId = seasonId
        self.getConstructorsPage = getConstructorsPage
        self.pageLimit = pageLimit
        self._state = State(initialValue: .initial)
    }

    init(seasonId: Season.ID, previewState: ViewState) {
        self.seasonId = seasonId
        self.getConstructorsPage = { seasonId, request in
            _ = seasonId
            return try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.pageLimit = 30
        self._state = State(initialValue: previewState)
    }

    public var body: some View {
        content
            .navigationTitle("\(seasonId.rawValue) Constructors")
            .task {
                if shouldLoadInitialPage {
                    await loadInitialPage()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if state.isLoadingInitial {
            ProgressView("Loading constructors...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if state.items.isEmpty, let error = state.error {
            ContentUnavailableView {
                Label("Unable to Load Constructors", systemImage: "exclamationmark.triangle")
            } description: {
                Text(error)
            } actions: {
                Button("Retry") { Task { await loadInitialPage() } }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List {
                ForEach(state.items, id: \.id) { constructor in
                    F1UI.Constructor.Row(constructor)
                        .onAppear {
                            Task { await loadMoreIfNeeded(afterAppearing: constructor.id) }
                        }
                }

                if state.isLoadingMore {
                    footerProgressView
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

    private var footerProgressView: some View {
        HStack { Spacer(); ProgressView(); Spacer() }
    }

    private func footerRetryView(error: String) -> some View {
        VStack(spacing: F1Theme.Spacing.s) {
            Text(error)
                .font(F1Theme.Typography.meta)
                .foregroundStyle(F1Theme.Colors.textSecondary)
            Button("Retry") { Task { await loadNextPage() } }
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
            let page = try await getConstructorsPage(seasonId, request)
            state = Self.makeLoadedState(from: page)
        } catch {
            state = Self.makeInitialErrorState(from: error)
        }
    }

    @MainActor
    private func loadMoreIfNeeded(afterAppearing constructorId: String) async {
        guard constructorId == state.items.last?.id else { return }
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
            let page = try await getConstructorsPage(seasonId, request)
            state = Self.makeLoadedState(from: page, existingItems: currentItems)
        } catch {
            state = Self.makeLoadMoreErrorState(from: state, error: error)
        }
    }

    private func makePageRequest(offset: Int) -> PageRequest? {
        try? PageRequest(limit: pageLimit, offset: offset)
    }

    static func makeLoadedState(
        from page: Page<Constructor>,
        existingItems: [F1UI.Constructor.Row.ViewData] = []
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
        .init(items: [], isLoadingInitial: false, isLoadingMore: false, hasMore: true, nextOffset: 0, error: "Failed to load constructors. Please try again.")
    }

    static func makeLoadingMoreState(from state: ViewState) -> ViewState {
        .init(items: state.items, isLoadingInitial: false, isLoadingMore: true, hasMore: state.hasMore, nextOffset: state.nextOffset, error: nil)
    }

    static func makeLoadMoreErrorState(from state: ViewState, error: (any Error)? = nil) -> ViewState {
        .init(items: state.items, isLoadingInitial: false, isLoadingMore: false, hasMore: state.hasMore, nextOffset: state.nextOffset, error: "Failed to load constructors. Please try again.")
    }

    static func makeRowData(from constructor: Constructor) -> F1UI.Constructor.Row.ViewData {
        let style = TeamStyleRegistry.style(for: constructor.id.rawValue)
        return .init(
            id: constructor.id.rawValue,
            name: constructor.name,
            nationality: constructor.nationality,
            showsWikipediaIndicator: constructor.wikipediaURL != nil,
            teamStyleToken: style?.token,
            teamShortCode: style?.shortCode
        )
    }
}

extension ConstructorsScreen {
    typealias ViewState = PagedListState<F1UI.Constructor.Row.ViewData>
}

#Preview("Constructors Loading") {
    NavigationStack {
        ConstructorsScreen(seasonId: .init(rawValue: "2024"), previewState: .loadingInitial)
    }
}

#Preview("Constructors Error") {
    NavigationStack {
        ConstructorsScreen(seasonId: .init(rawValue: "2024"), previewState: ConstructorsScreen.makeInitialErrorState())
    }
}

#Preview("Constructors Loaded") {
    NavigationStack {
        ConstructorsScreen(
            seasonId: .init(rawValue: "2024"),
            previewState: .init(
                items: [
                    .init(id: "red_bull", name: "Red Bull Racing", nationality: "Austrian", showsWikipediaIndicator: true, teamStyleToken: .redBull, teamShortCode: "RBR"),
                    .init(id: "mclaren", name: "McLaren", nationality: "British", showsWikipediaIndicator: true, teamStyleToken: .mclaren, teamShortCode: "MCL")
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

#Preview("Constructors Loading More") {
    NavigationStack {
        ConstructorsScreen(
            seasonId: .init(rawValue: "2024"),
            previewState: .init(
                items: [
                    .init(id: "red_bull", name: "Red Bull Racing", nationality: "Austrian", showsWikipediaIndicator: true, teamStyleToken: .redBull, teamShortCode: "RBR"),
                    .init(id: "mclaren", name: "McLaren", nationality: "British", showsWikipediaIndicator: true, teamStyleToken: .mclaren, teamShortCode: "MCL")
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

#Preview("Constructors Load More Error") {
    NavigationStack {
        ConstructorsScreen(
            seasonId: .init(rawValue: "2024"),
            previewState: .init(
                items: [
                    .init(id: "red_bull", name: "Red Bull Racing", nationality: "Austrian", showsWikipediaIndicator: true, teamStyleToken: .redBull, teamShortCode: "RBR"),
                    .init(id: "mclaren", name: "McLaren", nationality: "British", showsWikipediaIndicator: true, teamStyleToken: .mclaren, teamShortCode: "MCL")
                ],
                isLoadingInitial: false,
                isLoadingMore: false,
                hasMore: true,
                nextOffset: 30,
                error: "Failed to load constructors. Please try again."
            )
        )
    }
}
