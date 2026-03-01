import Foundation
import Testing
@testable import F1Data

@Suite
struct SeasonsResponseDTOTests {
    let decoder: JSONDecoder

    init() {
        decoder = JSONDecoder()
    }

    @Test("SeasonsResponseDTO should decode seasons fixture")
    func testDecodingSucceeds() throws {
        // Given
        let data = try loadJSONFixture(named: "seasons")

        // When
        let response = try decoder.decode(SeasonsResponseDTO.self, from: data)

        // Then
        #expect(!response.mrData.seasonTable.seasons.isEmpty)
    }

    @Test("Decoded seasons count matches fixture")
    func testSeasonsCount() throws {
        // Given
        let expectedCount = 3
        let data = try loadJSONFixture(named: "seasons")

        // When
        let response = try decoder.decode(SeasonsResponseDTO.self, from: data)

        // Then
        #expect(response.mrData.seasonTable.seasons.count == expectedCount)
    }

    @Test("Decoded season fields match expected values")
    func testSeasonFields() throws {
        // Given
        let expectedSeason = "2023"
        let expectedURL = "https://en.wikipedia.org/wiki/2023_Formula_One_World_Championship"
        let data = try loadJSONFixture(named: "seasons")

        // When
        let response = try decoder.decode(SeasonsResponseDTO.self, from: data)
        let first = response.mrData.seasonTable.seasons[0]

        // Then
        #expect(first.season == expectedSeason)
        #expect(first.url == expectedURL)
    }

    @Test("Decoded seasons pagination fields match fixture")
    func testPaginationFields() throws {
        // Given
        let data = try loadJSONFixture(named: "seasons")

        // When
        let response = try decoder.decode(SeasonsResponseDTO.self, from: data)

        // Then
        #expect(response.mrData.total == "10")
        #expect(response.mrData.limit == "3")
        #expect(response.mrData.offset == "0")
    }
}
