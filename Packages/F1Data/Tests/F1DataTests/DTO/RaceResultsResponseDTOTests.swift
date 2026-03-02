import Foundation
import Testing
@testable import F1Data

@Suite
struct RaceResultsResponseDTOTests {
    @Test("RaceResultsResponseDTO should decode race results fixture and pagination metadata")
    func testRaceResultsFixtureDecoding() throws {
        // Given
        let data = try loadJSONFixture(named: "race_results_2023_round1")
        let decoder = JSONDecoder()

        // When
        let response = try decoder.decode(RaceResultsResponseDTO.self, from: data)

        // Then
        #expect(response.mrData.total == "20")
        #expect(response.mrData.limit == "2")
        #expect(response.mrData.offset == "0")
        #expect(response.mrData.raceTable.round == "1")
        #expect(response.mrData.raceTable.races.count == 1)
        #expect(response.mrData.raceTable.races[0].results.count == 2)
        #expect(response.mrData.raceTable.races[0].results[0].time?.time == "1:33:56.736")
    }
}
