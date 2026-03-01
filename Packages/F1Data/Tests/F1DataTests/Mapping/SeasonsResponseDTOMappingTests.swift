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

    @Test("SeasonsResponseDTO should decode and map pagination metadata")
    func testMappingPaginationMetadata() throws {
        // Given
        let data = try loadJSONFixture(named: "seasons")
        let decoder = JSONDecoder()
        let response = try decoder.decode(SeasonsResponseDTO.self, from: data)

        // When
        let page = try response.toPage()

        // Then
        #expect(response.mrData.total == "10")
        #expect(response.mrData.limit == "3")
        #expect(response.mrData.offset == "0")
        #expect(page.total == 10)
        #expect(page.limit == 3)
        #expect(page.offset == 0)
        #expect(page.hasMore == true)
    }
}
