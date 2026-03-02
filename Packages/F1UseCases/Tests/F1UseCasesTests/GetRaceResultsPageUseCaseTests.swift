import F1Domain
import Foundation
import Testing
@testable import F1UseCases

@Suite
struct GetRaceResultsPageUseCaseTests {
    @Test("GetRaceResultsPageUseCase forwards season id round and request and returns the repository page")
    func callAsFunction_forwardsParameters_andReturnsPage() async throws {
        // Given
        let seasonId = Season.ID(rawValue: "2024")
        let round = Race.Round(rawValue: "5")
        let request = try PageRequest(limit: 20, offset: 40)
        let driver = Driver(
            id: Driver.ID(rawValue: "charles_leclerc"),
            givenName: "Charles",
            familyName: "Leclerc",
            dateOfBirth: Date(timeIntervalSince1970: 914_803_200),
            nationality: "Monegasque",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Charles_Leclerc")
        )
        let constructor = Constructor(
            id: Constructor.ID(rawValue: "ferrari"),
            name: "Ferrari",
            nationality: "Italian",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Scuderia_Ferrari")
        )
        let expectedPage = try Page(
            items: [
                RaceResult(
                    seasonId: seasonId,
                    round: round,
                    raceName: "Chinese Grand Prix",
                    date: Date(timeIntervalSince1970: 1_713_664_800),
                    time: Race.Time(hour: 7, minute: 0, second: 0, utcOffsetSeconds: 0),
                    driver: driver,
                    constructor: constructor,
                    grid: 2,
                    position: 1,
                    positionText: "1",
                    points: 25,
                    laps: 56,
                    status: "Finished",
                    resultTime: .time("1:40:52.554")
                )
            ],
            total: 20,
            limit: 20,
            offset: 40
        )
        let repository = F1RepositoryMock(raceResultsPageResult: .success(expectedPage))
        let sut = GetRaceResultsPageUseCase(repository: repository)

        // When
        let page = try await sut(seasonId: seasonId, round: round, request: request)

        // Then
        #expect(page == expectedPage)
        #expect(await repository.raceResultsPageCallCount == 1)
        #expect(await repository.receivedSeasonId == seasonId)
        #expect(await repository.receivedRound == round)
        #expect(await repository.receivedPageRequest == request)
    }

    @Test("GetRaceResultsPageUseCase propagates repository errors")
    func callAsFunction_whenRepositoryFails_throwsRepositoryError() async throws {
        // Given
        let seasonId = Season.ID(rawValue: "2024")
        let round = Race.Round(rawValue: "5")
        let request = try PageRequest(limit: 20, offset: 40)
        let expectedError = RepositoryError.sample
        let repository = F1RepositoryMock(raceResultsPageResult: .failure(expectedError))
        let sut = GetRaceResultsPageUseCase(repository: repository)

        // When
        let thrownError = await #expect(throws: RepositoryError.self) {
            try await sut(seasonId: seasonId, round: round, request: request)
        }

        // Then
        #expect(thrownError == expectedError)
        #expect(await repository.raceResultsPageCallCount == 1)
        #expect(await repository.receivedSeasonId == seasonId)
        #expect(await repository.receivedRound == round)
        #expect(await repository.receivedPageRequest == request)
    }
}

private enum RepositoryError: Error {
    case sample
}
