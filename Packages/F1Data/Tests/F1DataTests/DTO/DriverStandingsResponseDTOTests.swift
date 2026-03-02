import Foundation
import Testing
@testable import F1Data

@Suite
struct DriverStandingsResponseDTOTests {
    @Test("DriverStandingsResponseDTO should decode driver standings fixture and pagination metadata")
    func testDriverStandingsFixtureDecoding() throws {
        // Given
        let data = try loadJSONFixture(named: "driver_standings_2023")
        let decoder = JSONDecoder()

        // When
        let response = try decoder.decode(DriverStandingsResponseDTO.self, from: data)

        // Then
        #expect(response.mrData.total == "22")
        #expect(response.mrData.limit == "2")
        #expect(response.mrData.offset == "0")
        #expect(response.mrData.standingsTable.standingsLists.count == 1)
        #expect(response.mrData.standingsTable.standingsLists[0].driverStandings.count == 2)
        #expect(response.mrData.standingsTable.standingsLists[0].driverStandings[0].wins == "19")
    }
}
