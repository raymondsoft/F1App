import Foundation
import F1Domain
import Testing
@testable import F1UI

@MainActor
@Suite
struct DriverStandingsScreenTests {
    @Test("Loaded state maps driver standings into row view data")
    func loadedStateMapping() throws {
        // Given
        let page = try Page(
            items: [
                DriverStanding(
                    seasonId: .init(rawValue: "2024"),
                    position: 1,
                    points: 575,
                    wins: 9,
                    driver: Driver(
                        id: .init(rawValue: "max_verstappen"),
                        givenName: "Max",
                        familyName: "Verstappen",
                        dateOfBirth: nil,
                        nationality: "Dutch",
                        wikipediaURL: URL(string: "https://example.com/max")
                    ),
                    constructors: [
                        Constructor(
                            id: .init(rawValue: "red_bull"),
                            name: "Red Bull Racing",
                            nationality: "Austrian",
                            wikipediaURL: URL(string: "https://example.com/red-bull")
                        )
                    ]
                )
            ],
            total: 1,
            limit: 30,
            offset: 0
        )
        let expectedState = DriverStandingsScreen.ViewState(
            items: [
                .init(
                    id: "2024-max_verstappen",
                    positionText: "1",
                    title: "Max Verstappen",
                    subtitle: "Red Bull Racing",
                    pointsText: "575 pts",
                    winsText: "9 wins"
                )
            ],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: false,
            nextOffset: 30,
            error: nil
        )

        // When
        let state = DriverStandingsScreen.makeLoadedState(from: page)

        // Then
        #expect(state == expectedState)
    }

    @Test("Initial error state uses a user-friendly retry message")
    func initialErrorStateUsesUserFriendlyMessage() {
        // Given
        let error = DriverStandingsScreenTestError()

        // When
        let state = DriverStandingsScreen.makeInitialErrorState(from: error)

        // Then
        #expect(state == .init(
            items: [],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 0,
            error: "Failed to load driver standings. Please try again."
        ))
    }
}

private struct DriverStandingsScreenTestError: LocalizedError {
    var errorDescription: String? { "The driver standings request failed." }
}
