import Foundation
import Testing
@testable import F1Data

@Suite
struct ConstructorStandingsResponseDTOTests {
    @Test("ConstructorStandingsResponseDTO should decode constructor standings fixture and pagination metadata")
    func testConstructorStandingsFixtureDecoding() throws {
        // Given
        let data = try loadJSONFixture(named: "constructor_standings_2023")
        let decoder = JSONDecoder()

        // When
        let response = try decoder.decode(ConstructorStandingsResponseDTO.self, from: data)

        // Then
        #expect(response.mrData.total == "10")
        #expect(response.mrData.limit == "2")
        #expect(response.mrData.offset == "0")
        #expect(response.mrData.standingsTable.standingsLists.count == 1)
        #expect(response.mrData.standingsTable.standingsLists[0].constructorStandings.count == 2)
        #expect(response.mrData.standingsTable.standingsLists[0].constructorStandings[0].constructor.constructorId == "red_bull")
    }
}
