import Foundation
import Testing
@testable import F1Domain

@Suite
struct SeasonTests {
    @Test("Seasons with the same values are equal and hash the same")
    func seasonsWithSameValuesAreEqual() {
        // Given
        let wikipediaURL = URL(string: "https://en.wikipedia.org/wiki/2024_Formula_One_World_Championship")
        let firstSeason = Season(
            id: .init(rawValue: "2024"),
            wikipediaURL: wikipediaURL
        )
        let secondSeason = Season(
            id: .init(rawValue: "2024"),
            wikipediaURL: wikipediaURL
        )

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
}
