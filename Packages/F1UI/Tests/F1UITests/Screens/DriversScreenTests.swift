import Foundation
import F1Domain
import Testing
@testable import F1UI

@MainActor
@Suite
struct DriversScreenTests {
    @Test("Loaded state maps a drivers page into row view data")
    func loadedStateMapping() throws {
        // Given
        let page = try Page(
            items: [
                Driver(
                    id: .init(rawValue: "max_verstappen"),
                    givenName: "Max",
                    familyName: "Verstappen",
                    dateOfBirth: nil,
                    nationality: "Dutch",
                    wikipediaURL: URL(string: "https://example.com/max")
                ),
                Driver(
                    id: .init(rawValue: "lando_norris"),
                    givenName: "Lando",
                    familyName: "Norris",
                    dateOfBirth: nil,
                    nationality: "British",
                    wikipediaURL: nil
                )
            ],
            total: 4,
            limit: 2,
            offset: 0
        )
        let expectedState = DriversScreen.ViewState(
            items: [
                .init(id: "max_verstappen", name: "Max Verstappen", nationality: "Dutch", showsWikipediaIndicator: true),
                .init(id: "lando_norris", name: "Lando Norris", nationality: "British", showsWikipediaIndicator: false)
            ],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 2,
            error: nil
        )

        // When
        let state = DriversScreen.makeLoadedState(from: page)

        // Then
        #expect(state == expectedState)
    }

    @Test("Load more error state keeps driver items and uses a user-friendly message")
    func loadMoreErrorStateKeepsExistingItems() {
        // Given
        let stateBeforeError = DriversScreen.ViewState(
            items: [
                .init(id: "max_verstappen", name: "Max Verstappen", nationality: "Dutch", showsWikipediaIndicator: true)
            ],
            isLoadingInitial: false,
            isLoadingMore: true,
            hasMore: true,
            nextOffset: 30,
            error: nil
        )

        // When
        let state = DriversScreen.makeLoadMoreErrorState(from: stateBeforeError, error: DriversScreenTestError())

        // Then
        #expect(state == .init(
            items: [
                .init(id: "max_verstappen", name: "Max Verstappen", nationality: "Dutch", showsWikipediaIndicator: true)
            ],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 30,
            error: "Failed to load drivers. Please try again."
        ))
    }
}

private struct DriversScreenTestError: LocalizedError {
    var errorDescription: String? { "The drivers request failed." }
}
