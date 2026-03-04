import Foundation
import F1Domain
import Testing
@testable import F1UI

@MainActor
@Suite
struct ConstructorStandingsScreenTests {
    @Test("Loaded state maps constructor standings into row view data")
    func loadedStateMapping() throws {
        // Given
        let page = try Page(
            items: [
                ConstructorStanding(
                    seasonId: .init(rawValue: "2024"),
                    position: 1,
                    points: 666,
                    wins: 6,
                    constructor: Constructor(
                        id: .init(rawValue: "mclaren"),
                        name: "McLaren",
                        nationality: "British",
                        wikipediaURL: URL(string: "https://example.com/mclaren")
                    )
                )
            ],
            total: 1,
            limit: 30,
            offset: 0
        )
        let expectedState = ConstructorStandingsScreen.ViewState(
            items: [
                .init(
                    id: "2024-mclaren",
                    positionText: "1",
                    title: "McLaren",
                    subtitle: "British",
                    pointsText: "666 pts",
                    winsText: "6 wins",
                    position: 1,
                    pointsValue: 666,
                    maxPointsValue: 666,
                    winsCount: 6
                )
            ],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: false,
            nextOffset: 30,
            error: nil
        )

        // When
        let state = ConstructorStandingsScreen.makeLoadedState(from: page)

        // Then
        #expect(state == expectedState)
    }

    @Test("Load more error state keeps constructor standings and uses a user-friendly message")
    func loadMoreErrorStateKeepsExistingItems() {
        // Given
        let stateBeforeError = ConstructorStandingsScreen.ViewState(
            items: [
                .init(
                    id: "2024-mclaren",
                    positionText: "1",
                    title: "McLaren",
                    subtitle: "British",
                    pointsText: "666 pts",
                    winsText: "6 wins"
                )
            ],
            isLoadingInitial: false,
            isLoadingMore: true,
            hasMore: true,
            nextOffset: 30,
            error: nil
        )

        // When
        let state = ConstructorStandingsScreen.makeLoadMoreErrorState(
            from: stateBeforeError,
            error: ConstructorStandingsScreenTestError()
        )

        // Then
        #expect(state == .init(
            items: [
                .init(
                    id: "2024-mclaren",
                    positionText: "1",
                    title: "McLaren",
                    subtitle: "British",
                    pointsText: "666 pts",
                    winsText: "6 wins"
                )
            ],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 30,
            error: "Failed to load constructor standings. Please try again."
        ))
    }
}

private struct ConstructorStandingsScreenTestError: LocalizedError {
    var errorDescription: String? { "The constructor standings request failed." }
}
