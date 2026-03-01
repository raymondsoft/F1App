import Foundation
import F1Domain
import Testing
@testable import F1UI

@MainActor
@Suite
struct SeasonsScreenTests {
    @Test("Loaded state maps the first seasons page into row view data")
    func loadedStateMappingForFirstPage() throws {
        // Given
        let page = try Page(
            items: [
                Season(
                    id: Season.ID(rawValue: "2024"),
                    wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/2024_Formula_One_World_Championship")
                ),
                Season(
                    id: Season.ID(rawValue: "1950"),
                    wikipediaURL: nil
                )
            ],
            total: 4,
            limit: 2,
            offset: 0
        )
        let expectedState = SeasonsScreen.ViewState(
            items: [
                .init(id: "2024", title: "2024", showsWikipediaIndicator: true),
                .init(id: "1950", title: "1950", showsWikipediaIndicator: false)
            ],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 2,
            error: nil
        )

        // When
        let state = SeasonsScreen.makeLoadedState(from: page)

        // Then
        #expect(state == expectedState)
    }

    @Test("Loaded state appends a later seasons page without duplicating existing ids")
    func loadedStateAppendsAndDeduplicates() throws {
        // Given
        let existingItems: [F1UI.Season.Row.ViewData] = [
            .init(id: "2024", title: "2024", showsWikipediaIndicator: true),
            .init(id: "2023", title: "2023", showsWikipediaIndicator: false)
        ]
        let page = try Page(
            items: [
                Season(
                    id: Season.ID(rawValue: "2023"),
                    wikipediaURL: nil
                ),
                Season(
                    id: Season.ID(rawValue: "2022"),
                    wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/2022_Formula_One_World_Championship")
                )
            ],
            total: 3,
            limit: 2,
            offset: 2
        )
        let expectedState = SeasonsScreen.ViewState(
            items: [
                .init(id: "2024", title: "2024", showsWikipediaIndicator: true),
                .init(id: "2023", title: "2023", showsWikipediaIndicator: false),
                .init(id: "2022", title: "2022", showsWikipediaIndicator: true)
            ],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: false,
            nextOffset: 4,
            error: nil
        )

        // When
        let state = SeasonsScreen.makeLoadedState(from: page, existingItems: existingItems)

        // Then
        #expect(state == expectedState)
    }

    @Test("Initial error state uses a user-friendly retry message")
    func initialErrorStateUsesUserFriendlyMessage() {
        // Given
        let error = SeasonsScreenTestError()

        // When
        let state = SeasonsScreen.makeInitialErrorState(from: error)

        // Then
        #expect(state == .init(
            items: [],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 0,
            error: "Failed to load seasons. Please try again."
        ))
    }

    @Test("Load more error state keeps existing items and clears loading more")
    func loadMoreErrorStateKeepsExistingItems() {
        // Given
        let stateBeforeError = SeasonsScreen.ViewState(
            items: [
                .init(id: "2024", title: "2024", showsWikipediaIndicator: true)
            ],
            isLoadingInitial: false,
            isLoadingMore: true,
            hasMore: true,
            nextOffset: 30,
            error: nil
        )
        let error = SeasonsScreenTestError()

        // When
        let state = SeasonsScreen.makeLoadMoreErrorState(from: stateBeforeError, error: error)

        // Then
        #expect(state == .init(
            items: [
                .init(id: "2024", title: "2024", showsWikipediaIndicator: true)
            ],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 30,
            error: "Failed to load seasons. Please try again."
        ))
    }
}

private struct SeasonsScreenTestError: LocalizedError {
    var errorDescription: String? {
        "The seasons request failed."
    }
}
