import F1Domain
import Foundation
import Testing
@testable import F1UseCases

@Suite
struct GetQualifyingResultsPageUseCaseTests {
    @Test("GetQualifyingResultsPageUseCase forwards season id round and request and returns the repository page")
    func callAsFunction_forwardsParameters_andReturnsPage() async throws {
        // Given
        let seasonId = Season.ID(rawValue: "2024")
        let round = Race.Round(rawValue: "7")
        let request = try PageRequest(limit: 20, offset: 0)
        let driver = Driver(
            id: Driver.ID(rawValue: "lando_norris"),
            givenName: "Lando",
            familyName: "Norris",
            dateOfBirth: Date(timeIntervalSince1970: 946_857_600),
            nationality: "British",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Lando_Norris")
        )
        let constructor = Constructor(
            id: Constructor.ID(rawValue: "mclaren"),
            name: "McLaren",
            nationality: "British",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/McLaren")
        )
        let expectedPage = try Page(
            items: [
                QualifyingResult(
                    seasonId: seasonId,
                    round: round,
                    driver: driver,
                    constructor: constructor,
                    position: 1,
                    q1: QualifyingLapTime(rawValue: "1:11.245"),
                    q2: QualifyingLapTime(rawValue: "1:10.912"),
                    q3: QualifyingLapTime(rawValue: "1:10.321")
                )
            ],
            total: 20,
            limit: 20,
            offset: 0
        )
        let repository = F1RepositoryMock(qualifyingResultsPageResult: .success(expectedPage))
        let sut = GetQualifyingResultsPageUseCase(repository: repository)

        // When
        let page = try await sut(seasonId: seasonId, round: round, request: request)

        // Then
        #expect(page == expectedPage)
        #expect(await repository.qualifyingResultsPageCallCount == 1)
        #expect(await repository.receivedSeasonId == seasonId)
        #expect(await repository.receivedRound == round)
        #expect(await repository.receivedPageRequest == request)
    }

    @Test("GetQualifyingResultsPageUseCase propagates repository errors")
    func callAsFunction_whenRepositoryFails_throwsRepositoryError() async throws {
        // Given
        let seasonId = Season.ID(rawValue: "2024")
        let round = Race.Round(rawValue: "7")
        let request = try PageRequest(limit: 20, offset: 0)
        let expectedError = RepositoryError.sample
        let repository = F1RepositoryMock(qualifyingResultsPageResult: .failure(expectedError))
        let sut = GetQualifyingResultsPageUseCase(repository: repository)

        // When
        let thrownError = await #expect(throws: RepositoryError.self) {
            try await sut(seasonId: seasonId, round: round, request: request)
        }

        // Then
        #expect(thrownError == expectedError)
        #expect(await repository.qualifyingResultsPageCallCount == 1)
        #expect(await repository.receivedSeasonId == seasonId)
        #expect(await repository.receivedRound == round)
        #expect(await repository.receivedPageRequest == request)
    }
}

private enum RepositoryError: Error {
    case sample
}
