import Foundation
import Testing
@testable import F1Data

@Suite
struct SeasonsResponseDTOTests {
    let decoder: JSONDecoder

    init() {
        decoder = JSONDecoder()
    }

    @Test("Decoding seasons fixture succeeds")
    func testDecodingSucceeds() throws {
        // Given
        // When
        let response = try decodeSeasonsFixture()

        // Then
        #expect(!response.mrData.seasonTable.seasons.isEmpty)
    }

    @Test("Decoded seasons count matches fixture")
    func testSeasonsCount() throws {
        // Given
        let expectedCount = 3

        // When
        let response = try decodeSeasonsFixture()

        // Then
        #expect(response.mrData.seasonTable.seasons.count == expectedCount)
    }

    @Test("Decoded season fields match expected values")
    func testSeasonFields() throws {
        // Given
        let expectedSeason = "2023"
        let expectedURL = "https://en.wikipedia.org/wiki/2023_Formula_One_World_Championship"

        // When
        let response = try decodeSeasonsFixture()
        let first = response.mrData.seasonTable.seasons[0]

        // Then
        #expect(first.season == expectedSeason)
        #expect(first.url == expectedURL)
    }

    private func decodeSeasonsFixture() throws -> SeasonsResponseDTO {
        let data = try loadJSONFixture(named: "seasons")
        return try decoder.decode(SeasonsResponseDTO.self, from: data)
    }
}
