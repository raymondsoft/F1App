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
        let data = try loadFixture(named: "seasons")

        // When
        let response = try decoder.decode(SeasonsResponseDTO.self, from: data)

        // Then
        #expect(!response.mrData.seasonTable.seasons.isEmpty)
    }

    @Test("Decoded seasons count matches fixture")
    func testSeasonsCount() throws {
        // Given
        let data = try loadFixture(named: "seasons")

        // When
        let response = try decoder.decode(SeasonsResponseDTO.self, from: data)

        // Then
        #expect(response.mrData.seasonTable.seasons.count == 3)
    }

    @Test("Decoded season fields match expected values")
    func testSeasonFields() throws {
        // Given
        let data = try loadFixture(named: "seasons")

        // When
        let response = try decoder.decode(SeasonsResponseDTO.self, from: data)
        let first = response.mrData.seasonTable.seasons[0]

        // Then
        #expect(first.season == "2023")
        #expect(first.url == "https://en.wikipedia.org/wiki/2023_Formula_One_World_Championship")
    }

    private func loadFixture(named name: String) throws -> Data {
        let fixtureURL = try #require(Bundle.module.url(forResource: name, withExtension: "json"))
        return try Data(contentsOf: fixtureURL)
    }
}
