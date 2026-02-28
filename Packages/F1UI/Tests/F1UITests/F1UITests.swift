import Foundation
import F1Domain
import Testing
@testable import F1UI

@MainActor
@Suite
struct CircuitRowTests {
    @Test("Circuit row view data preserves the location and wikipedia indicator used for rendering")
    func viewDataPreservesRenderingFields() {
        // Given
        let viewData = F1UI.Circuit.Row.ViewData(
            id: "silverstone",
            name: "Silverstone Circuit",
            locality: "Silverstone",
            country: "United Kingdom",
            showsWikipediaIndicator: true
        )

        // When
        let _ = F1UI.Circuit.Row(viewData)

        // Then
        #expect(viewData.id == "silverstone")
        #expect(viewData.name == "Silverstone Circuit")
        #expect(viewData.locality == "Silverstone")
        #expect(viewData.country == "United Kingdom")
        #expect(viewData.showsWikipediaIndicator)
    }
}

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
                )
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
                )
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
}

@MainActor
@Suite
struct SeasonsScreenTests {
    @Test("Loaded state maps season identifiers and wikipedia availability into row view data")
    func loadedStateMapping() {
        // Given
        let seasons = [
            Season(
                id: Season.ID(rawValue: "2024"),
                wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/2024_Formula_One_World_Championship")
            ),
            Season(
                id: Season.ID(rawValue: "1950"),
                wikipediaURL: nil
            )
        ]
        let expectedRows: [F1UI.Season.Row.ViewData] = [
            .init(id: "2024", title: "2024", showsWikipediaIndicator: true),
            .init(id: "1950", title: "1950", showsWikipediaIndicator: false)
        ]

        // When
        let state = SeasonsScreen.makeLoadedState(from: seasons)

        // Then
        #expect(state == .loaded(expectedRows))
    }

    @Test("Error state uses a user-friendly retry message")
    func errorStateUsesUserFriendlyMessage() {
        // Given
        let error = SeasonsScreenTestError()

        // When
        let state = SeasonsScreen.makeErrorState(from: error)

        // Then
        #expect(state == .error("Failed to load seasons. Please try again."))
    }
}

private struct SeasonsScreenTestError: LocalizedError {
    var errorDescription: String? {
        "The seasons request failed."
    }
}

private struct RacesScreenTestError: LocalizedError {
    var errorDescription: String? {
        "The races request failed."
    }
}
