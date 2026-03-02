import Foundation
import Testing
import F1Domain
@testable import F1Data

@Suite
struct RaceResultsResponseDTOMappingTests {
    @Test("RaceResultsResponseDTO should map race results fixture to a paged domain response")
    func testRaceResultsMapping() throws {
        // Given
        let data = try loadJSONFixture(named: "race_results_2023_round1")
        let decoder = JSONDecoder()
        let response = try decoder.decode(RaceResultsResponseDTO.self, from: data)
        let expectedDate = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: TimeZone(secondsFromGMT: 0),
            year: 2023,
            month: 3,
            day: 5
        ).date

        // When
        let page = try response.toPage()

        // Then
        #expect(page.items.count == 2)
        #expect(page.total == 20)
        #expect(page.hasMore == true)
        #expect(page.items[0].seasonId == Season.ID(rawValue: "2023"))
        #expect(page.items[0].round == Race.Round(rawValue: "1"))
        #expect(page.items[0].raceName == "Bahrain Grand Prix")
        #expect(page.items[0].date == expectedDate)
        #expect(page.items[0].time == Race.Time(hour: 15, minute: 0, second: 0, utcOffsetSeconds: 0))
        #expect(page.items[0].grid == 1)
        #expect(page.items[0].points == 25)
        #expect(page.items[0].resultTime == .time("1:33:56.736"))
        #expect(page.items[1].resultTime == .time("+11.987s"))
    }

    @Test("RaceResultsResponseDTO should classify non-time status strings as status values")
    func testRaceResultsStatusClassification() throws {
        // Given
        let response = RaceResultsResponseDTO(
            mrData: .init(
                total: "20",
                limit: "1",
                offset: "0",
                raceTable: .init(
                    season: "2023",
                    round: "1",
                    races: [
                        .init(
                            season: "2023",
                            round: "1",
                            raceName: "Bahrain Grand Prix",
                            date: "2023-03-05",
                            time: "15:00:00Z",
                            results: [
                                .init(
                                    position: nil,
                                    positionText: "R",
                                    points: "0",
                                    driver: .init(
                                        driverId: "alonso",
                                        url: "https://en.wikipedia.org/wiki/Fernando_Alonso",
                                        givenName: "Fernando",
                                        familyName: "Alonso",
                                        dateOfBirth: "1981-07-29",
                                        nationality: "Spanish"
                                    ),
                                    constructor: .init(
                                        constructorId: "aston_martin",
                                        url: "https://en.wikipedia.org/wiki/Aston_Martin_in_Formula_One",
                                        name: "Aston Martin",
                                        nationality: "British"
                                    ),
                                    grid: "5",
                                    laps: "10",
                                    status: "Collision",
                                    time: nil
                                )
                            ]
                        )
                    ]
                )
            )
        )

        // When
        let page = try response.toPage()

        // Then
        #expect(page.items[0].resultTime == .status("Collision"))
    }

    @Test("RaceResultsResponseDTO should throw mapping error for invalid numeric fields")
    func testRaceResultsMappingInvalidNumericValue() {
        // Given
        let response = RaceResultsResponseDTO(
            mrData: .init(
                total: "20",
                limit: "1",
                offset: "0",
                raceTable: .init(
                    season: "2023",
                    round: "1",
                    races: [
                        .init(
                            season: "2023",
                            round: "1",
                            raceName: "Bahrain Grand Prix",
                            date: "2023-03-05",
                            time: "15:00:00Z",
                            results: [
                                .init(
                                    position: "1",
                                    positionText: "1",
                                    points: "oops",
                                    driver: .init(
                                        driverId: "max_verstappen",
                                        url: "https://en.wikipedia.org/wiki/Max_Verstappen",
                                        givenName: "Max",
                                        familyName: "Verstappen",
                                        dateOfBirth: "1997-09-30",
                                        nationality: "Dutch"
                                    ),
                                    constructor: .init(
                                        constructorId: "red_bull",
                                        url: "https://en.wikipedia.org/wiki/Red_Bull_Racing",
                                        name: "Red Bull",
                                        nationality: "Austrian"
                                    ),
                                    grid: "1",
                                    laps: "57",
                                    status: "Finished",
                                    time: .init(time: "1:33:56.736")
                                )
                            ]
                        )
                    ]
                )
            )
        )

        // When
        do {
            _ = try response.toPage()
            Issue.record("Expected DataError.mapping to be thrown")
        } catch let error as DataError {
            // Then
            #expect(error == .mapping(underlying: "Invalid points: oops"))
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }
}
