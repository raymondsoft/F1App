import Foundation
import Testing
@testable import F1Domain

@Suite
struct SeasonTests {
    @Test("Seasons with the same values are equal and hash the same")
    func seasonsWithSameValuesAreEqual() {
        // Given
        let firstSeason = Season.fixture(id: .init(rawValue: "2024"))
        let secondSeason = Season.fixture(id: .init(rawValue: "2024"))

        // When
        let seasons = Set([firstSeason, secondSeason])

        // Then
        #expect(firstSeason == secondSeason)
        #expect(seasons.count == 1)
    }

    @Test("Season identifier preserves its raw value")
    func seasonIdentifierPreservesRawValue() {
        // Given
        let seasonID = Season.ID(rawValue: "1950")

        // When
        let rawValue = seasonID.rawValue

        // Then
        #expect(rawValue == "1950")
    }

    @Test("Season supports a missing wikipedia URL")
    func seasonSupportsMissingWikipediaURL() {
        // Given
        let season = Season.fixture(
            id: .init(rawValue: "1950"),
            wikipediaURL: nil
        )

        // When
        let wikipediaURL = season.wikipediaURL

        // Then
        #expect(wikipediaURL == nil)
    }
}
