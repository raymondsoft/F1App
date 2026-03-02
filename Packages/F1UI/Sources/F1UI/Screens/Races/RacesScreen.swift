import Foundation
import F1Domain
import F1UseCases
import SwiftUI

public struct RacesScreen: View {
    @State private var state: ViewState

    private let seasonId: Season.ID
    private let getRaces: @Sendable (Season.ID) async throws -> [Race]
    private let getRaceResultsPage: @Sendable (Season.ID, Race.Round, PageRequest) async throws -> Page<RaceResult>
    private let getQualifyingResultsPage: @Sendable (Season.ID, Race.Round, PageRequest) async throws -> Page<QualifyingResult>

    public init(
        seasonId: Season.ID,
        getRacesForSeasonUseCase: GetRacesForSeasonUseCase,
        getRaceResultsPageUseCase: GetRaceResultsPageUseCase,
        getQualifyingResultsPageUseCase: GetQualifyingResultsPageUseCase
    ) {
        self.seasonId = seasonId
        self.getRaces = { selectedSeasonId in
            try await getRacesForSeasonUseCase(seasonId: selectedSeasonId)
        }
        self.getRaceResultsPage = { seasonId, round, request in
            try await getRaceResultsPageUseCase(seasonId: seasonId, round: round, request: request)
        }
        self.getQualifyingResultsPage = { seasonId, round, request in
            try await getQualifyingResultsPageUseCase(seasonId: seasonId, round: round, request: request)
        }
        self._state = SwiftUI.State(initialValue: .idle)
    }

    init(
        seasonId: Season.ID,
        getRaces: @escaping @Sendable (Season.ID) async throws -> [Race],
        getRaceResultsPage: @escaping @Sendable (Season.ID, Race.Round, PageRequest) async throws -> Page<RaceResult>,
        getQualifyingResultsPage: @escaping @Sendable (Season.ID, Race.Round, PageRequest) async throws -> Page<QualifyingResult>
    ) {
        self.seasonId = seasonId
        self.getRaces = getRaces
        self.getRaceResultsPage = getRaceResultsPage
        self.getQualifyingResultsPage = getQualifyingResultsPage
        self._state = SwiftUI.State(initialValue: .idle)
    }

    init(seasonId: Season.ID, previewState state: ViewState) {
        self.seasonId = seasonId
        self.getRaces = { _ in [] }
        self.getRaceResultsPage = { _, _, request in
            try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self.getQualifyingResultsPage = { _, _, request in
            try Page(items: [], total: 0, limit: request.limit, offset: request.offset)
        }
        self._state = SwiftUI.State(initialValue: state)
    }

    public var body: some View {
        content
            .navigationTitle("\(seasonId.rawValue) Races")
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
                if let route = Self.makeRouteIdentifiers(from: race.id) {
                    Section {
                        NavigationLink {
                            RaceResultsScreen(
                                seasonId: route.seasonId,
                                round: route.round,
                                getRaceResultsPage: getRaceResultsPage
                            )
                        } label: {
                            F1UI.Race.Row(race)
                        }

                        NavigationLink {
                            QualifyingResultsScreen(
                                seasonId: route.seasonId,
                                round: route.round,
                                getQualifyingResultsPage: getQualifyingResultsPage
                            )
                        } label: {
                            Label("Qualifying", systemImage: "timer")
                        }
                    }
                } else {
                    F1UI.Race.Row(race)
                }
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

        let baseTime = String(
            format: "%02d:%02d:%02d",
            locale: Locale(identifier: "en_US_POSIX"),
            time.hour,
            time.minute,
            time.second
        )

        guard time.utcOffsetSeconds != 0 else {
            return baseTime
        }

        return "\(baseTime) \(makeUTCOffsetText(from: time.utcOffsetSeconds))"
    }

    private static func makeUTCOffsetText(from utcOffsetSeconds: Int) -> String {
        let sign = utcOffsetSeconds >= 0 ? "+" : "-"
        let absoluteSeconds = abs(utcOffsetSeconds)
        let hours = absoluteSeconds / 3600
        let minutes = (absoluteSeconds % 3600) / 60

        return String(
            format: "UTC%@%02d:%02d",
            locale: Locale(identifier: "en_US_POSIX"),
            sign,
            hours,
            minutes
        )
    }

    private static func makeRouteIdentifiers(from id: String) -> (seasonId: Season.ID, round: Race.Round)? {
        let components = id.split(separator: "-", maxSplits: 1).map(String.init)

        guard components.count == 2 else {
            return nil
        }

        return (
            seasonId: Season.ID(rawValue: components[0]),
            round: Race.Round(rawValue: components[1])
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
        RacesScreen(seasonId: .init(rawValue: "2024"), previewState: .loading)
    }
}

#Preview("Races Error") {
    NavigationStack {
        RacesScreen(
            seasonId: .init(rawValue: "2024"),
            previewState: .error("Failed to load races. Please try again.")
        )
    }
}

#Preview("Races Loaded") {
    NavigationStack {
        RacesScreen(
            seasonId: .init(rawValue: "2024"),
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
