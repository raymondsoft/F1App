import Foundation
import Testing
import F1Domain
@testable import F1Data

@Suite
struct ConstructorStandingsResponseDTOMappingTests {
    @Test("ConstructorStandingsResponseDTO should map constructor standings fixture to a paged domain response")
    func testConstructorStandingsMapping() throws {
        // Given
        let data = try loadJSONFixture(named: "constructor_standings_2023")
        let decoder = JSONDecoder()
        let response = try decoder.decode(ConstructorStandingsResponseDTO.self, from: data)

        // When
        let page = try response.toPage()

        // Then
        #expect(page.items.count == 2)
        #expect(page.total == 10)
        #expect(page.hasMore == true)
        #expect(page.items[0].seasonId == Season.ID(rawValue: "2023"))
        #expect(page.items[0].position == 1)
        #expect(page.items[0].points == 860)
        #expect(page.items[0].wins == 21)
        #expect(page.items[0].constructor.id == Constructor.ID(rawValue: "red_bull"))
    }

    @Test("ConstructorStandingsResponseDTO should throw mapping error for invalid points")
    func testConstructorStandingsInvalidPoints() {
        // Given
        let response = ConstructorStandingsResponseDTO(
            mrData: .init(
                total: "10",
                limit: "1",
                offset: "0",
                standingsTable: .init(
                    season: "2023",
                    standingsLists: [
                        .init(
                            season: "2023",
                            constructorStandings: [
                                .init(
                                    position: "1",
                                    points: "oops",
                                    wins: "21",
                                    constructor: .init(
                                        constructorId: "red_bull",
                                        url: "https://en.wikipedia.org/wiki/Red_Bull_Racing",
                                        name: "Red Bull",
                                        nationality: "Austrian"
                                    )
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

    @Test("ConstructorStandingsResponseDTO should map invalid constructor wikipedia URL strings to nil")
    func testConstructorStandingsInvalidURLToNil() throws {
        // Given
        let response = ConstructorStandingsResponseDTO(
            mrData: .init(
                total: "10",
                limit: "1",
                offset: "0",
                standingsTable: .init(
                    season: "2023",
                    standingsLists: [
                        .init(
                            season: "2023",
                            constructorStandings: [
                                .init(
                                    position: "1",
                                    points: "860",
                                    wins: "21",
                                    constructor: .init(
                                        constructorId: "red_bull",
                                        url: "https://exa mple.com",
                                        name: "Red Bull",
                                        nationality: "Austrian"
                                    )
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
        #expect(page.items[0].constructor.wikipediaURL == nil)
    }
}
