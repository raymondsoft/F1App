import F1Domain
import Foundation
import Testing
@testable import F1UseCases

@Suite
struct GetConstructorStandingsPageUseCaseTests {
    @Test("GetConstructorStandingsPageUseCase forwards season id and request and returns the repository page")
    func callAsFunction_forwardsSeasonIdAndRequest_andReturnsPage() async throws {
        // Given
        let seasonId = Season.ID(rawValue: "2024")
        let request = try PageRequest(limit: 10, offset: 10)
        let constructor = Constructor(
            id: Constructor.ID(rawValue: "ferrari"),
            name: "Ferrari",
            nationality: "Italian",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Scuderia_Ferrari")
        )
        let expectedPage = try Page(
            items: [
                ConstructorStanding(
                    seasonId: seasonId,
                    position: 2,
                    points: 612,
                    wins: 5,
                    constructor: constructor
                )
            ],
            total: 10,
            limit: 10,
            offset: 10
        )
        let repository = F1RepositoryMock(constructorStandingsPageResult: .success(expectedPage))
        let sut = GetConstructorStandingsPageUseCase(repository: repository)

        // When
        let page = try await sut(seasonId: seasonId, request: request)

        // Then
        #expect(page == expectedPage)
        #expect(await repository.constructorStandingsPageCallCount == 1)
        #expect(await repository.receivedSeasonId == seasonId)
        #expect(await repository.receivedPageRequest == request)
    }

    @Test("GetConstructorStandingsPageUseCase propagates repository errors")
    func callAsFunction_whenRepositoryFails_throwsRepositoryError() async throws {
        // Given
        let seasonId = Season.ID(rawValue: "2024")
        let request = try PageRequest(limit: 10, offset: 10)
        let expectedError = RepositoryError.sample
        let repository = F1RepositoryMock(constructorStandingsPageResult: .failure(expectedError))
        let sut = GetConstructorStandingsPageUseCase(repository: repository)

        // When
        let thrownError = await #expect(throws: RepositoryError.self) {
            try await sut(seasonId: seasonId, request: request)
        }

        // Then
        #expect(thrownError == expectedError)
        #expect(await repository.constructorStandingsPageCallCount == 1)
        #expect(await repository.receivedSeasonId == seasonId)
        #expect(await repository.receivedPageRequest == request)
    }
}

private enum RepositoryError: Error {
    case sample
}
