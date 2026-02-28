import Foundation
import Testing
import F1Domain
@testable import F1Data

@Suite
struct SeasonsResponseDTOMappingTests {
    @Test("SeasonsResponseDTO should map seasons fixture to domain seasons")
    func testMappingSeasonsFixture() throws {
        // Given
        let data = try loadJSONFixture(named: "seasons")
        let decoder = JSONDecoder()
        let response = try decoder.decode(SeasonsResponseDTO.self, from: data)

        // When
        let seasons = response.toDomain()

        // Then
        #expect(seasons.count == 3)
        #expect(seasons[0].id == Season.ID(rawValue: "2023"))
        #expect(seasons[0].wikipediaURL == URL(string: "https://en.wikipedia.org/wiki/2023_Formula_One_World_Championship"))
    }
}
