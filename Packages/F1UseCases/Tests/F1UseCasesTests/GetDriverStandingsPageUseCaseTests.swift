import F1Domain
import Foundation
import Testing
@testable import F1UseCases

@Suite
struct GetDriverStandingsPageUseCaseTests {
    @Test("GetDriverStandingsPageUseCase forwards season id and request and returns the repository page")
    func callAsFunction_forwardsSeasonIdAndRequest_andReturnsPage() async throws {
        // Given
        let seasonId = Season.ID(rawValue: "2024")
        let request = try PageRequest(limit: 20, offset: 20)
        let driver = Driver(
            id: Driver.ID(rawValue: "george_russell"),
            givenName: "George",
            familyName: "Russell",
            dateOfBirth: Date(timeIntervalSince1970: 914_544_000),
            nationality: "British",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/George_Russell_(racing_driver)")
        )
        let constructor = Constructor(
            id: Constructor.ID(rawValue: "mercedes"),
            name: "Mercedes",
            nationality: "German",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Mercedes-Benz_in_Formula_One")
        )
        let expectedPage = try Page(
            items: [
                DriverStanding(
                    seasonId: seasonId,
                    position: 6,
                    points: 175,
                    wins: 1,
                    driver: driver,
                    constructors: [constructor]
                )
            ],
            total: 20,
            limit: 20,
            offset: 20
        )
        let repository = F1RepositoryMock(driverStandingsPageResult: .success(expectedPage))
        let sut = GetDriverStandingsPageUseCase(repository: repository)

        // When
        let page = try await sut(seasonId: seasonId, request: request)

        // Then
        #expect(page == expectedPage)
        #expect(await repository.driverStandingsPageCallCount == 1)
        #expect(await repository.receivedSeasonId == seasonId)
        #expect(await repository.receivedPageRequest == request)
    }

    @Test("GetDriverStandingsPageUseCase propagates repository errors")
    func callAsFunction_whenRepositoryFails_throwsRepositoryError() async throws {
        // Given
        let seasonId = Season.ID(rawValue: "2024")
        let request = try PageRequest(limit: 20, offset: 20)
        let expectedError = RepositoryError.sample
        let repository = F1RepositoryMock(driverStandingsPageResult: .failure(expectedError))
        let sut = GetDriverStandingsPageUseCase(repository: repository)

        // When
        let thrownError = await #expect(throws: RepositoryError.self) {
            try await sut(seasonId: seasonId, request: request)
        }

        // Then
        #expect(thrownError == expectedError)
        #expect(await repository.driverStandingsPageCallCount == 1)
        #expect(await repository.receivedSeasonId == seasonId)
        #expect(await repository.receivedPageRequest == request)
    }
}

private enum RepositoryError: Error {
    case sample
}
