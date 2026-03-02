import Foundation
import F1Domain
import Testing
@testable import F1UI

@MainActor
@Suite
struct ConstructorsScreenTests {
    @Test("Loaded state maps a constructors page into row view data")
    func loadedStateMapping() throws {
        // Given
        let page = try Page(
            items: [
                Constructor(
                    id: .init(rawValue: "red_bull"),
                    name: "Red Bull Racing",
                    nationality: "Austrian",
                    wikipediaURL: URL(string: "https://example.com/red-bull")
                ),
                Constructor(
                    id: .init(rawValue: "mclaren"),
                    name: "McLaren",
                    nationality: "British",
                    wikipediaURL: nil
                )
            ],
            total: 4,
            limit: 2,
            offset: 0
        )
        let expectedState = ConstructorsScreen.ViewState(
            items: [
                .init(id: "red_bull", name: "Red Bull Racing", nationality: "Austrian", showsWikipediaIndicator: true),
                .init(id: "mclaren", name: "McLaren", nationality: "British", showsWikipediaIndicator: false)
            ],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 2,
            error: nil
        )

        // When
        let state = ConstructorsScreen.makeLoadedState(from: page)

        // Then
        #expect(state == expectedState)
    }

    @Test("Initial error state uses a user-friendly retry message")
    func initialErrorStateUsesUserFriendlyMessage() {
        // Given
        let error = ConstructorsScreenTestError()

        // When
        let state = ConstructorsScreen.makeInitialErrorState(from: error)

        // Then
        #expect(state == .init(
            items: [],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 0,
            error: "Failed to load constructors. Please try again."
        ))
    }
}

private struct ConstructorsScreenTestError: LocalizedError {
    var errorDescription: String? { "The constructors request failed." }
}
