import Foundation
import Testing
@testable import F1Data

@Suite
struct QualifyingResultsResponseDTOTests {
    @Test("QualifyingResultsResponseDTO should decode qualifying fixture and pagination metadata")
    func testQualifyingFixtureDecoding() throws {
        // Given
        let data = try loadJSONFixture(named: "qualifying_results_2023_round1")
        let decoder = JSONDecoder()

        // When
        let response = try decoder.decode(QualifyingResultsResponseDTO.self, from: data)

        // Then
        #expect(response.mrData.total == "20")
        #expect(response.mrData.limit == "2")
        #expect(response.mrData.offset == "0")
        #expect(response.mrData.raceTable.round == "1")
        #expect(response.mrData.raceTable.races[0].qualifyingResults.count == 2)
        #expect(response.mrData.raceTable.races[0].qualifyingResults[0].q3 == "1:29.708")
    }
}
