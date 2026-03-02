import Foundation
import Testing
import F1Domain
@testable import F1Data

@Suite
struct QualifyingResultsResponseDTOMappingTests {
    @Test("QualifyingResultsResponseDTO should map qualifying fixture to a paged domain response")
    func testQualifyingResultsMapping() throws {
        // Given
        let data = try loadJSONFixture(named: "qualifying_results_2023_round1")
        let decoder = JSONDecoder()
        let response = try decoder.decode(QualifyingResultsResponseDTO.self, from: data)

        // When
        let page = try response.toPage()

        // Then
        #expect(page.items.count == 2)
        #expect(page.total == 20)
        #expect(page.hasMore == true)
        #expect(page.items[0].seasonId == Season.ID(rawValue: "2023"))
        #expect(page.items[0].round == Race.Round(rawValue: "1"))
        #expect(page.items[0].position == 1)
        #expect(page.items[0].q1 == QualifyingLapTime(rawValue: "1:30.503"))
        #expect(page.items[0].q3 == QualifyingLapTime(rawValue: "1:29.708"))
    }

    @Test("QualifyingResultsResponseDTO should throw mapping error for invalid numeric position")
    func testQualifyingResultsInvalidPosition() {
        // Given
        let response = QualifyingResultsResponseDTO(
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
                            qualifyingResults: [
                                .init(
                                    position: "P1",
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
                                    q1: "1:30.503",
                                    q2: "1:30.503",
                                    q3: "1:29.708"
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
            #expect(error == .mapping(underlying: "Invalid position: P1"))
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test("QualifyingResultsResponseDTO should map invalid driver wikipedia URL strings to nil")
    func testQualifyingResultsInvalidDriverURLToNil() throws {
        // Given
        let response = QualifyingResultsResponseDTO(
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
                            qualifyingResults: [
                                .init(
                                    position: "1",
                                    driver: .init(
                                        driverId: "max_verstappen",
                                        url: "https://exa mple.com",
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
                                    q1: "1:30.503",
                                    q2: nil,
                                    q3: nil
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
        #expect(page.items[0].driver.wikipediaURL == nil)
    }
}
