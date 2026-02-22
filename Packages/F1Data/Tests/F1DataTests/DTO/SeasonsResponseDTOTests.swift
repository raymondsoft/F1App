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
        let expectedFixtureName = "seasons"

        // When
        let response = try decodeFixture(named: expectedFixtureName)

        // Then
        #expect(!response.mrData.seasonTable.seasons.isEmpty)
    }

    @Test("Decoded seasons count matches fixture")
    func testSeasonsCount() throws {
        // Given
        let expectedCount = 3

        // When
        let response = try decodeFixture()

        // Then
        #expect(response.mrData.seasonTable.seasons.count == expectedCount)
    }

    @Test("Decoded season fields match expected values")
    func testSeasonFields() throws {
        // Given
        let expectedSeason = "2023"
        let expectedURL = "https://en.wikipedia.org/wiki/2023_Formula_One_World_Championship"

        // When
        let response = try decodeFixture()
        let first = response.mrData.seasonTable.seasons[0]

        // Then
        #expect(first.season == expectedSeason)
        #expect(first.url == expectedURL)
    }

    private func decodeFixture(named name: String = "seasons") throws -> SeasonsResponseDTO {
        let data = try loadJSONFixture(named: name)
        return try decoder.decode(SeasonsResponseDTO.self, from: data)
    }
}
