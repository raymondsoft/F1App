import Foundation
import F1Domain
import Testing
@testable import F1UI

@MainActor
@Suite
struct RaceResultsScreenTests {
    @Test("Loaded state maps race results into row view data")
    func loadedStateMapping() throws {
        // Given
        let page = try Page(
            items: [
                RaceResult(
                    seasonId: .init(rawValue: "2024"),
                    round: .init(rawValue: "1"),
                    raceName: "Bahrain Grand Prix",
                    date: Date(timeIntervalSince1970: 1_709_294_400),
                    time: Race.Time(hour: 15, minute: 0, second: 0),
                    driver: Driver(
                        id: .init(rawValue: "max_verstappen"),
                        givenName: "Max",
                        familyName: "Verstappen",
                        dateOfBirth: nil,
                        nationality: "Dutch",
                        wikipediaURL: URL(string: "https://example.com/max")
                    ),
                    constructor: Constructor(
                        id: .init(rawValue: "red_bull"),
                        name: "Red Bull Racing",
                        nationality: "Austrian",
                        wikipediaURL: URL(string: "https://example.com/red-bull")
                    ),
                    grid: 1,
                    position: 1,
                    positionText: "1",
                    points: 25,
                    laps: 57,
                    status: "Finished",
                    resultTime: .time("1:31:44.742")
                )
            ],
            total: 1,
            limit: 30,
            offset: 0
        )
        let expectedState = RaceResultsScreen.ViewState(
            items: [
                .init(
                    id: "2024-1-max_verstappen",
                    positionText: "1",
                    position: 1,
                    driverName: "Max Verstappen",
                    constructorName: "Red Bull Racing",
                    pointsText: "25 pts",
                    resultChip: .init(text: "1:31:44.742", style: .time),
                    teamStyleToken: .redBull,
                    teamShortCode: "RBR"
                )
            ],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: false,
            nextOffset: 30,
            error: nil
        )

        // When
        let state = RaceResultsScreen.makeLoadedState(from: page)

        // Then
        #expect(state == expectedState)
    }

    @Test("Initial error state uses a user-friendly retry message")
    func initialErrorStateUsesUserFriendlyMessage() {
        // Given
        let error = RaceResultsScreenTestError()

        // When
        let state = RaceResultsScreen.makeInitialErrorState(from: error)

        // Then
        #expect(state == .init(
            items: [],
            isLoadingInitial: false,
            isLoadingMore: false,
            hasMore: true,
            nextOffset: 0,
            error: "Failed to load race results. Please try again."
        ))
    }
}

private struct RaceResultsScreenTestError: LocalizedError {
    var errorDescription: String? { "The race results request failed." }
}
