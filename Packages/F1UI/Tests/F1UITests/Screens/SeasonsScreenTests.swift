import Foundation
import F1Domain
import Testing
@testable import F1UI

@MainActor
@Suite
struct SeasonsScreenTests {
    @Test("Loaded state maps season identifiers and wikipedia availability into row view data")
    func loadedStateMapping() {
        // Given
        let seasons = [
            Season(
                id: Season.ID(rawValue: "2024"),
                wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/2024_Formula_One_World_Championship")
            ),
            Season(
                id: Season.ID(rawValue: "1950"),
                wikipediaURL: nil
            )
        ]
        let expectedRows: [F1UI.Season.Row.ViewData] = [
            .init(id: "2024", title: "2024", showsWikipediaIndicator: true),
            .init(id: "1950", title: "1950", showsWikipediaIndicator: false)
        ]

        // When
        let state = SeasonsScreen.makeLoadedState(from: seasons)

        // Then
        #expect(state == .loaded(expectedRows))
    }

    @Test("Error state uses a user-friendly retry message")
    func errorStateUsesUserFriendlyMessage() {
        // Given
        let error = SeasonsScreenTestError()

        // When
        let state = SeasonsScreen.makeErrorState(from: error)

        // Then
        #expect(state == .error("Failed to load seasons. Please try again."))
    }
}

private struct SeasonsScreenTestError: LocalizedError {
    var errorDescription: String? {
        "The seasons request failed."
    }
}
