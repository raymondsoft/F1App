import Foundation
import F1Domain
import Testing
@testable import F1UI

@MainActor
@Suite
struct RacesScreenTests {
    @Test("Loaded state maps race details and circuit details into row view data")
    func loadedStateMapping() {
        // Given
        let race = Race(
            seasonId: Season.ID(rawValue: "2024"),
            round: Race.Round(rawValue: "1"),
            name: "Bahrain Grand Prix",
            date: Date(timeIntervalSince1970: 1_709_294_400),
            time: Race.Time(hour: 15, minute: 0, second: 0),
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/2024_Bahrain_Grand_Prix"),
            circuit: Circuit(
                id: Circuit.ID(rawValue: "bahrain"),
                name: "Bahrain International Circuit",
                wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit"),
                location: Location(
                    latitude: 26.0325,
                    longitude: 50.5106,
                    locality: "Sakhir",
                    country: "Bahrain"
                )
            )
        )
        let expectedRows: [F1UI.Race.Row.ViewData] = [
            .init(
                id: "2024-1",
                roundText: "Round 1",
                title: "Bahrain Grand Prix",
                dateText: "2024-03-01",
                timeText: "15:00:00",
                circuit: .init(
                    id: "bahrain",
                    name: "Bahrain International Circuit",
                    locality: "Sakhir",
                    country: "Bahrain",
                    showsWikipediaIndicator: true
                ),
                circuitWikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit")
            )
        ]

        // When
        let state = RacesScreen.makeLoadedState(from: [race])

        // Then
        #expect(state == .loaded(expectedRows))
    }

    @Test("Loaded state preserves non-zero race time offsets in the rendered time text")
    func loadedStateMappingIncludesTimeOffset() {
        // Given
        let race = Race(
            seasonId: Season.ID(rawValue: "2024"),
            round: Race.Round(rawValue: "2"),
            name: "Saudi Arabian Grand Prix",
            date: Date(timeIntervalSince1970: 1_709_899_200),
            time: Race.Time(hour: 20, minute: 0, second: 0, utcOffsetSeconds: 10_800),
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/2024_Saudi_Arabian_Grand_Prix"),
            circuit: Circuit(
                id: Circuit.ID(rawValue: "jeddah"),
                name: "Jeddah Corniche Circuit",
                wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Jeddah_Corniche_Circuit"),
                location: Location(
                    latitude: 21.6319,
                    longitude: 39.1044,
                    locality: "Jeddah",
                    country: "Saudi Arabia"
                )
            )
        )
        let expectedRows: [F1UI.Race.Row.ViewData] = [
            .init(
                id: "2024-2",
                roundText: "Round 2",
                title: "Saudi Arabian Grand Prix",
                dateText: "2024-03-08",
                timeText: "20:00:00 UTC+03:00",
                circuit: .init(
                    id: "jeddah",
                    name: "Jeddah Corniche Circuit",
                    locality: "Jeddah",
                    country: "Saudi Arabia",
                    showsWikipediaIndicator: true
                ),
                circuitWikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Jeddah_Corniche_Circuit")
            )
        ]

        // When
        let state = RacesScreen.makeLoadedState(from: [race])

        // Then
        #expect(state == .loaded(expectedRows))
    }

    @Test("Error state uses a user-friendly retry message")
    func errorStateUsesUserFriendlyMessage() {
        // Given
        let error = RacesScreenTestError()

        // When
        let state = RacesScreen.makeErrorState(from: error)

        // Then
        #expect(state == .error("Failed to load races. Please try again."))
    }

    @Test("Race detail loader assembles loaded state from first results and qualifying pages")
    func loadRaceDetailStateSuccess() async throws {
        // Given
        let race = F1UI.Race.Row.ViewData(
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
            ),
            circuitWikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit")
        )
        let raceResultsPage = try Page(
            items: [
                RaceResult(
                    seasonId: .init(rawValue: "2024"),
                    round: .init(rawValue: "1"),
                    raceName: "Bahrain Grand Prix",
                    date: Date(timeIntervalSince1970: 1_709_294_400),
                    time: Race.Time(hour: 15, minute: 0, second: 0),
                    driver: Driver(
                        id: .init(rawValue: "max_verstappen"),
                        givenName: "Max",
                        familyName: "Verstappen",
                        dateOfBirth: nil,
                        nationality: "Dutch",
                        wikipediaURL: URL(string: "https://example.com/max")
                    ),
                    constructor: Constructor(
                        id: .init(rawValue: "red_bull"),
                        name: "Red Bull Racing",
                        nationality: "Austrian",
                        wikipediaURL: URL(string: "https://example.com/red-bull")
                    ),
                    grid: 1,
                    position: 1,
                    positionText: "1",
                    points: 25,
                    laps: 57,
                    status: "Finished",
                    resultTime: .time("1:31:44.742")
                )
            ],
            total: 1,
            limit: 30,
            offset: 0
        )
        let qualifyingResultsPage = try Page(
            items: [
                QualifyingResult(
                    seasonId: .init(rawValue: "2024"),
                    round: .init(rawValue: "1"),
                    driver: Driver(
                        id: .init(rawValue: "max_verstappen"),
                        givenName: "Max",
                        familyName: "Verstappen",
                        dateOfBirth: nil,
                        nationality: "Dutch",
                        wikipediaURL: URL(string: "https://example.com/max")
                    ),
                    constructor: Constructor(
                        id: .init(rawValue: "red_bull"),
                        name: "Red Bull Racing",
                        nationality: "Austrian",
                        wikipediaURL: URL(string: "https://example.com/red-bull")
                    ),
                    position: 1,
                    q1: .init(rawValue: "1:29.421"),
                    q2: .init(rawValue: "1:29.374"),
                    q3: .init(rawValue: "1:29.179")
                )
            ],
            total: 1,
            limit: 30,
            offset: 0
        )

        // When
        let state = await RacesScreen.loadRaceDetailState(
            for: race,
            seasonId: .init(rawValue: "2024"),
            round: .init(rawValue: "1"),
            getRaceResultsPage: { _, _, _ in raceResultsPage },
            getQualifyingResultsPage: { _, _, _ in qualifyingResultsPage }
        )

        // Then
        switch state {
        case .loaded(let loaded):
            #expect(loaded.header.title == "Bahrain Grand Prix")
            #expect(loaded.header.circuitName == "Bahrain International Circuit")
            #expect(loaded.results.count == 1)
            #expect(loaded.qualifying.count == 1)
            #expect(loaded.circuit.name == "Bahrain International Circuit")
            #expect(loaded.circuit.wikipediaURL == URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit"))
        default:
            Issue.record("Expected loaded race detail state.")
        }
    }

    @Test("Race detail loader returns a user-friendly error when any detail request fails")
    func loadRaceDetailStateFailure() async {
        // Given
        let race = F1UI.Race.Row.ViewData(
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
            ),
            circuitWikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit")
        )
        let error = RacesScreenTestError()

        // When
        let state = await RacesScreen.loadRaceDetailState(
            for: race,
            seasonId: .init(rawValue: "2024"),
            round: .init(rawValue: "1"),
            getRaceResultsPage: { _, _, _ in throw error },
            getQualifyingResultsPage: { _, _, _ in
                try Page(items: [], total: 0, limit: 30, offset: 0)
            }
        )

        // Then
        #expect(state == .error("Failed to load race details. Please try again."))
    }

    @Test("Race detail header mapping keeps race and circuit metadata")
    func makeDetailHeaderDataMapping() {
        // Given
        let race = F1UI.Race.Row.ViewData(
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
            ),
            circuitWikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit")
        )

        // When
        let header = RacesScreen.makeDetailHeaderData(from: race)

        // Then
        #expect(header.id == "2024-1")
        #expect(header.title == "Bahrain Grand Prix")
        #expect(header.dateText == "2024-03-02")
        #expect(header.timeText == "15:00:00")
        #expect(header.circuitName == "Bahrain International Circuit")
        #expect(header.locality == "Sakhir")
        #expect(header.country == "Bahrain")
        #expect(header.wikipediaURL == URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit"))
    }

    @Test("Circuit summary mapping keeps circuit metadata and wikipedia url")
    func makeCircuitSummaryDataMapping() {
        // Given
        let race = F1UI.Race.Row.ViewData(
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
            ),
            circuitWikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit")
        )

        // When
        let summary = RacesScreen.makeCircuitSummaryData(from: race)

        // Then
        #expect(summary.id == "bahrain")
        #expect(summary.name == "Bahrain International Circuit")
        #expect(summary.locality == "Sakhir")
        #expect(summary.country == "Bahrain")
        #expect(summary.coordinatesText == nil)
        #expect(summary.wikipediaURL == URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit"))
    }
}

private struct RacesScreenTestError: LocalizedError {
    var errorDescription: String? {
        "The races request failed."
    }
}
