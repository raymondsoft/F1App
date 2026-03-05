import Foundation
import F1Domain
import Testing
@testable import F1UI

@MainActor
@Suite
struct QualifyingResultsScreenTests {
    @Test("Loaded state maps qualifying results into row view data")
    func loadedStateMapping() throws {
        // Given
        let page = try Page(
            items: [
                QualifyingResult(
                    seasonId: .init(rawValue: "2024"),
                    round: .init(rawValue: "1"),
                    driver: Driver(
                        id: .init(rawValue: "charles_leclerc"),
                        givenName: "Charles",
                        familyName: "Leclerc",
                        dateOfBirth: nil,
                        nationality: "Monégasque",
                        wikipediaURL: URL(string: "https://example.com/leclerc")
                    ),
                    constructor: Constructor(
                        id: .init(rawValue: "ferrari"),
                        name: "Ferrari",
                        nationality: "Italian",
                        wikipediaURL: URL(string: "https://example.com/ferrari")
                    ),
                    position: 2,
                    q1: .init(rawValue: "1:29.500"),
                    q2: .init(rawValue: "1:29.401"),
                    q3: .init(rawValue: "1:29.407")
                )
            ],
            total: 1,
            limit: 30,
            offset: 0
        )
        let expectedState = QualifyingResultsScreen.ViewState(
            items: [
                .init(
                    id: "2024-1-charles_leclerc",
                    positionText: "2",
                    position: 2,
                    driverName: "Charles Leclerc",
                    constructorName: "Ferrari",
                    q1Text: "1:29.500",
                    q2Text: "1:29.401",
                    q3Text: "1:29.407",
                    teamStyleToken: .ferrari,
                    teamShortCode: "FER"
                )
            ],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: false,
            nextOffset: 30,
            error: nil
        )

        // When
        let state = QualifyingResultsScreen.makeLoadedState(from: page)

        // Then
        #expect(state == expectedState)
    }

    @Test("Load more error state keeps qualifying items and clears the loading flag")
    func loadMoreErrorStateKeepsExistingItems() {
        // Given
        let stateBeforeError = QualifyingResultsScreen.ViewState(
            items: [
                .init(
                    id: "2024-1-charles_leclerc",
                    positionText: "2",
                    position: 2,
                    driverName: "Charles Leclerc",
                    constructorName: "Ferrari",
                    q1Text: "1:29.500",
                    q2Text: "1:29.401",
                    q3Text: "1:29.407",
                    teamStyleToken: .ferrari,
                    teamShortCode: "FER"
                )
            ],
            isLoadingInitial: false,
            isLoadingMore: true,
            hasMore: true,
            nextOffset: 30,
            error: nil
        )

        // When
        let state = QualifyingResultsScreen.makeLoadMoreErrorState(
            from: stateBeforeError,
            error: QualifyingResultsScreenTestError()
        )

        // Then
        #expect(state == .init(
            items: [
                .init(
                    id: "2024-1-charles_leclerc",
                    positionText: "2",
                    position: 2,
                    driverName: "Charles Leclerc",
                    constructorName: "Ferrari",
                    q1Text: "1:29.500",
                    q2Text: "1:29.401",
                    q3Text: "1:29.407",
                    teamStyleToken: .ferrari,
                    teamShortCode: "FER"
                )
            ],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 30,
            error: "Failed to load qualifying results. Please try again."
        ))
    }
}

private struct QualifyingResultsScreenTestError: LocalizedError {
    var errorDescription: String? { "The qualifying results request failed." }
}
