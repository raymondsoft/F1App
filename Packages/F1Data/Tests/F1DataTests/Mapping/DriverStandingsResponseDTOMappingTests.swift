import Foundation
import Testing
import F1Domain
@testable import F1Data

@Suite
struct DriverStandingsResponseDTOMappingTests {
    @Test("DriverStandingsResponseDTO should map driver standings fixture to a paged domain response")
    func testDriverStandingsMapping() throws {
        // Given
        let data = try loadJSONFixture(named: "driver_standings_2023")
        let decoder = JSONDecoder()
        let response = try decoder.decode(DriverStandingsResponseDTO.self, from: data)

        // When
        let page = try response.toPage()

        // Then
        #expect(page.items.count == 2)
        #expect(page.total == 22)
        #expect(page.hasMore == true)
        #expect(page.items[0].seasonId == Season.ID(rawValue: "2023"))
        #expect(page.items[0].position == 1)
        #expect(page.items[0].points == 575)
        #expect(page.items[0].wins == 19)
        #expect(page.items[0].constructors[0].id == Constructor.ID(rawValue: "red_bull"))
    }

    @Test("DriverStandingsResponseDTO should throw mapping error for invalid wins")
    func testDriverStandingsInvalidWins() {
        // Given
        let response = DriverStandingsResponseDTO(
            mrData: .init(
                total: "22",
                limit: "1",
                offset: "0",
                standingsTable: .init(
                    season: "2023",
                    standingsLists: [
                        .init(
                            season: "2023",
                            driverStandings: [
                                .init(
                                    position: "1",
                                    points: "575",
                                    wins: "x",
                                    driver: .init(
                                        driverId: "max_verstappen",
                                        url: "https://en.wikipedia.org/wiki/Max_Verstappen",
                                        givenName: "Max",
                                        familyName: "Verstappen",
                                        dateOfBirth: "1997-09-30",
                                        nationality: "Dutch"
                                    ),
                                    constructors: [
                                        .init(
                                            constructorId: "red_bull",
                                            url: "https://en.wikipedia.org/wiki/Red_Bull_Racing",
                                            name: "Red Bull",
                                            nationality: "Austrian"
                                        )
                                    ]
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
            #expect(error == .mapping(underlying: "Invalid wins: x"))
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test("DriverStandingsResponseDTO should map invalid constructor wikipedia URL strings to nil")
    func testDriverStandingsInvalidConstructorURLToNil() throws {
        // Given
        let response = DriverStandingsResponseDTO(
            mrData: .init(
                total: "22",
                limit: "1",
                offset: "0",
                standingsTable: .init(
                    season: "2023",
                    standingsLists: [
                        .init(
                            season: "2023",
                            driverStandings: [
                                .init(
                                    position: "1",
                                    points: "575",
                                    wins: "19",
                                    driver: .init(
                                        driverId: "max_verstappen",
                                        url: "https://en.wikipedia.org/wiki/Max_Verstappen",
                                        givenName: "Max",
                                        familyName: "Verstappen",
                                        dateOfBirth: "1997-09-30",
                                        nationality: "Dutch"
                                    ),
                                    constructors: [
                                        .init(
                                            constructorId: "red_bull",
                                            url: "https://exa mple.com",
                                            name: "Red Bull",
                                            nationality: "Austrian"
                                        )
                                    ]
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
        #expect(page.items[0].constructors[0].wikipediaURL == nil)
    }
}
