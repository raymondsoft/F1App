import F1Domain
import F1UseCases
import SwiftUI

public struct SeasonsScreen: View {
    @State private var state: ViewState

    private let getSeasonsUseCase: GetSeasonsUseCase?

    public init(getSeasonsUseCase: GetSeasonsUseCase) {
        self.getSeasonsUseCase = getSeasonsUseCase
        self._state = SwiftUI.State(initialValue: .idle)
    }

    init(previewState state: ViewState) {
        self.getSeasonsUseCase = nil
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
            List(seasons, id: \.title) { season in
                F1UI.Season.Row(season)
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
        guard let getSeasonsUseCase else {
            return
        }

        state = .loading

        do {
            let seasons = try await getSeasonsUseCase()
            state = .loaded(seasons.map(Self.makeRowData))
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    private static func makeRowData(from season: Season) -> F1UI.Season.Row.ViewData {
        .init(
            title: season.id.rawValue,
            showsWikipediaIndicator: season.wikipediaURL != nil
        )
    }
}

extension SeasonsScreen {
    enum ViewState {
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
            .init(title: "2024", showsWikipediaIndicator: true),
            .init(title: "2023", showsWikipediaIndicator: false),
            .init(title: "2022", showsWikipediaIndicator: true)
        ])
    )
}
