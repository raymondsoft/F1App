import F1Domain
import F1UseCases
import SwiftUI

public struct SeasonsScreen: View {
    @State private var state: ViewState

    private let getSeasons: @Sendable () async throws -> [Season]
    private let getRaces: @Sendable (String) async throws -> [Race]

    public init(
        getSeasonsUseCase: GetSeasonsUseCase,
        getRacesForSeasonUseCase: GetRacesForSeasonUseCase
    ) {
        self.getSeasons = { try await getSeasonsUseCase() }
        self.getRaces = { seasonId in
            try await getRacesForSeasonUseCase(seasonId: Season.ID(rawValue: seasonId))
        }
        self._state = SwiftUI.State(initialValue: .idle)
    }

    init(previewState state: ViewState) {
        self.getSeasons = { [] }
        self.getRaces = { _ in [] }
        self._state = SwiftUI.State(initialValue: state)
    }

    public var body: some View {
        NavigationStack {
            content
                .navigationTitle("Seasons")
        }
        .task {
            if case .idle = state {
                await loadSeasons()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .idle, .loading:
            ProgressView("Loading seasons...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let seasons):
            List(seasons, id: \.id) { season in
                NavigationLink {
                    RacesScreen(seasonId: season.id, getRaces: getRaces)
                } label: {
                    F1UI.Season.Row(season)
                }
            }

        case .error(let message):
            ContentUnavailableView {
                Label("Unable to Load Seasons", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Retry") {
                    Task {
                        await loadSeasons()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    @MainActor
    private func loadSeasons() async {
        state = .loading

        do {
            let seasons = try await getSeasons()
            state = Self.makeLoadedState(from: seasons)
        } catch {
            state = Self.makeErrorState(from: error)
        }
    }

    static func makeLoadedState(from seasons: [Season]) -> ViewState {
        .loaded(seasons.map(Self.makeRowData))
    }

    static func makeErrorState(from error: any Error) -> ViewState {
        .error("Failed to load seasons. Please try again.")
    }

    static func makeRowData(from season: Season) -> F1UI.Season.Row.ViewData {
        .init(
            id: season.id.rawValue,
            title: season.id.rawValue,
            showsWikipediaIndicator: season.wikipediaURL != nil
        )
    }
}

extension SeasonsScreen {
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded([F1UI.Season.Row.ViewData])
        case error(String)
    }
}

#Preview("Loading") {
    SeasonsScreen(previewState: .loading)
}

#Preview("Error") {
    SeasonsScreen(previewState: .error("The seasons could not be loaded."))
}

#Preview("Loaded") {
    SeasonsScreen(
        previewState: .loaded([
            .init(id: "2024", title: "2024", showsWikipediaIndicator: true),
            .init(id: "2023", title: "2023", showsWikipediaIndicator: false),
            .init(id: "2022", title: "2022", showsWikipediaIndicator: true)
        ])
    )
}
