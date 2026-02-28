import Foundation
import F1Domain
import F1UseCases
import SwiftUI

public struct RacesScreen: View {
    @State private var state: ViewState

    private let seasonId: String
    private let getRaces: @Sendable (String) async throws -> [Race]

    public init(seasonId: String, getRacesForSeasonUseCase: GetRacesForSeasonUseCase) {
        self.seasonId = seasonId
        self.getRaces = { selectedSeasonId in
            try await getRacesForSeasonUseCase(seasonId: Season.ID(rawValue: selectedSeasonId))
        }
        self._state = SwiftUI.State(initialValue: .idle)
    }

    init(
        seasonId: String,
        getRaces: @escaping @Sendable (String) async throws -> [Race]
    ) {
        self.seasonId = seasonId
        self.getRaces = getRaces
        self._state = SwiftUI.State(initialValue: .idle)
    }

    init(seasonId: String, previewState state: ViewState) {
        self.seasonId = seasonId
        self.getRaces = { _ in [] }
        self._state = SwiftUI.State(initialValue: state)
    }

    public var body: some View {
        content
            .navigationTitle("\(seasonId) Races")
            .task {
                if case .idle = state {
                    await loadRaces()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .idle, .loading:
            ProgressView("Loading races...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let races):
            List(races, id: \.id) { race in
                F1UI.Race.Row(race)
            }

        case .error(let message):
            ContentUnavailableView {
                Label("Unable to Load Races", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Retry") {
                    Task {
                        await loadRaces()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    @MainActor
    private func loadRaces() async {
        state = .loading

        do {
            let races = try await getRaces(seasonId)
            state = Self.makeLoadedState(from: races)
        } catch {
            state = Self.makeErrorState(from: error)
        }
    }

    static func makeLoadedState(from races: [Race]) -> ViewState {
        .loaded(races.map(Self.makeRowData))
    }

    static func makeErrorState(from error: any Error) -> ViewState {
        .error("Failed to load races. Please try again.")
    }

    static func makeRowData(from race: Race) -> F1UI.Race.Row.ViewData {
        .init(
            id: "\(race.seasonId.rawValue)-\(race.round.rawValue)",
            roundText: "Round \(race.round.rawValue)",
            title: race.name,
            dateText: makeDateText(from: race.date),
            timeText: makeTimeText(from: race.time),
            circuit: .init(
                id: race.circuit.id.rawValue,
                name: race.circuit.name,
                locality: race.circuit.location.locality,
                country: race.circuit.location.country,
                showsWikipediaIndicator: race.circuit.wikipediaURL != nil
            )
        )
    }

    private static func makeDateText(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private static func makeTimeText(from time: Race.Time?) -> String? {
        guard let time else {
            return nil
        }

        return String(
            format: "%02d:%02d:%02d",
            locale: Locale(identifier: "en_US_POSIX"),
            time.hour,
            time.minute,
            time.second
        )
    }
}

extension RacesScreen {
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded([F1UI.Race.Row.ViewData])
        case error(String)
    }
}

#Preview("Races Loading") {
    NavigationStack {
        RacesScreen(seasonId: "2024", previewState: .loading)
    }
}

#Preview("Races Error") {
    NavigationStack {
        RacesScreen(
            seasonId: "2024",
            previewState: .error("Failed to load races. Please try again.")
        )
    }
}

#Preview("Races Loaded") {
    NavigationStack {
        RacesScreen(
            seasonId: "2024",
            previewState: .loaded([
                .init(
                    id: "2024-1",
                    roundText: "Round 1",
                    title: "Bahrain Grand Prix",
                    dateText: "2024-03-02",
                    timeText: "15:00:00",
                    circuit: .init(
                        id: "bahrain",
                        name: "Bahrain International Circuit",
                        locality: "Sakhir",
                        country: "Bahrain",
                        showsWikipediaIndicator: true
                    )
                ),
                .init(
                    id: "2024-2",
                    roundText: "Round 2",
                    title: "Saudi Arabian Grand Prix",
                    dateText: "2024-03-09",
                    timeText: nil,
                    circuit: .init(
                        id: "jeddah",
                        name: "Jeddah Corniche Circuit",
                        locality: "Jeddah",
                        country: "Saudi Arabia",
                        showsWikipediaIndicator: true
                    )
                )
            ])
        )
    }
}
