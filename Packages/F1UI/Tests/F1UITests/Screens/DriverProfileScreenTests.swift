import Foundation
import F1Domain
import Testing
@testable import F1UI

@MainActor
@Suite
struct DriverProfileScreenTests {
    @Test("Season summary mapping uses standing values and points scaling")
    func makeSeasonSummaryDataWithStanding() {
        // Given
        let standing = DriverStanding(
            seasonId: .init(rawValue: "2024"),
            position: 1,
            points: 575,
            wins: 9,
            driver: Driver(
                id: .init(rawValue: "max_verstappen"),
                givenName: "Max",
                familyName: "Verstappen",
                dateOfBirth: nil,
                nationality: "Dutch",
                wikipediaURL: URL(string: "https://example.com/max")
            ),
            constructors: []
        )

        // When
        let summary = DriverProfileScreen.makeSeasonSummaryData(
            standing: standing,
            maxPoints: 700
        )

        // Then
        #expect(summary.positionText == "P1")
        #expect(summary.position == 1)
        #expect(summary.pointsText == "575 pts")
        #expect(summary.winsText == "9 wins")
        #expect(summary.pointsBar.value == 575)
        #expect(summary.pointsBar.maxValue == 700)
        #expect(summary.winsPips.wins == 9)
    }

    @Test("Recent results mapping sorts by date descending and formats row data")
    func makeRecentResultRows() {
        // Given
        let olderResult = RaceResult(
            seasonId: .init(rawValue: "2024"),
            round: .init(rawValue: "1"),
            raceName: "Bahrain Grand Prix",
            date: Date(timeIntervalSince1970: 1_709_294_400),
            time: nil,
            driver: Driver(
                id: .init(rawValue: "max_verstappen"),
                givenName: "Max",
                familyName: "Verstappen",
                dateOfBirth: nil,
                nationality: "Dutch",
                wikipediaURL: nil
            ),
            constructor: Constructor(
                id: .init(rawValue: "red_bull"),
                name: "Red Bull Racing",
                nationality: "Austrian",
                wikipediaURL: nil
            ),
            grid: 1,
            position: 1,
            positionText: "1",
            points: 25,
            laps: 57,
            status: "Finished",
            resultTime: .time("1:31:44.742")
        )
        let newerResult = RaceResult(
            seasonId: .init(rawValue: "2024"),
            round: .init(rawValue: "2"),
            raceName: "Saudi Arabian Grand Prix",
            date: Date(timeIntervalSince1970: 1_709_899_200),
            time: nil,
            driver: Driver(
                id: .init(rawValue: "max_verstappen"),
                givenName: "Max",
                familyName: "Verstappen",
                dateOfBirth: nil,
                nationality: "Dutch",
                wikipediaURL: nil
            ),
            constructor: Constructor(
                id: .init(rawValue: "red_bull"),
                name: "Red Bull Racing",
                nationality: "Austrian",
                wikipediaURL: nil
            ),
            grid: 1,
            position: 1,
            positionText: "1",
            points: 25,
            laps: 50,
            status: "Finished",
            resultTime: nil
        )

        // When
        let rows = DriverProfileScreen.makeRecentResultRows(from: [olderResult, newerResult])

        // Then
        #expect(rows.count == 2)
        #expect(rows[0].roundText == "Round 2")
        #expect(rows[0].raceName == "Saudi Arabian Grand Prix")
        #expect(rows[0].positionText == "P1")
        #expect(rows[0].resultChip == .init(text: "Finished", style: .status))
        #expect(rows[1].roundText == "Round 1")
        #expect(rows[1].resultChip == .init(text: "1:31:44.742", style: .time))
    }

    @Test("Header mapping prefers loaded driver identity over seed view data")
    func makeHeaderDataPrefersLoadedDriver() {
        // Given
        let viewData = DriverProfileScreen.ViewData(
            driverId: "max_verstappen",
            driverDisplayName: "Seed Name",
            nationality: "Seed Nationality",
            dateOfBirthText: "1999-01-01",
            wikipediaURL: URL(string: "https://example.com/seed")
        )
        let driver = Driver(
            id: .init(rawValue: "max_verstappen"),
            givenName: "Max",
            familyName: "Verstappen",
            dateOfBirth: Date(timeIntervalSince1970: 875_577_600),
            nationality: "Dutch",
            wikipediaURL: URL(string: "https://example.com/max")
        )

        // When
        let header = DriverProfileScreen.makeHeaderData(viewData: viewData, driver: driver)

        // Then
        #expect(header.displayName == "Max Verstappen")
        #expect(header.nationality == "Dutch")
        #expect(header.dateOfBirthText == "1997-09-30")
        #expect(header.wikipediaURL == URL(string: "https://example.com/max"))
    }

    @Test("Initial season selection uses preferred season when available")
    func makeInitialSeasonIdUsesPreferredSeason() {
        // Given
        let seasons = [
            Season(id: .init(rawValue: "2024"), wikipediaURL: nil),
            Season(id: .init(rawValue: "2023"), wikipediaURL: nil)
        ]

        // When
        let initialSeasonId = DriverProfileScreen.makeInitialSeasonId(
            preferredSeasonId: "2023",
            seasons: seasons
        )

        // Then
        #expect(initialSeasonId == .init(rawValue: "2023"))
    }
}
