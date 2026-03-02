import F1Domain
import Foundation
import Testing
@testable import F1UseCases

@Suite
struct GetDriversPageUseCaseTests {
    @Test("GetDriversPageUseCase forwards season id and request and returns the repository page")
    func callAsFunction_forwardsSeasonIdAndRequest_andReturnsPage() async throws {
        // Given
        let seasonId = Season.ID(rawValue: "2024")
        let request = try PageRequest(limit: 30, offset: 60)
        let expectedPage = try Page(
            items: [
                Driver(
                    id: Driver.ID(rawValue: "max_verstappen"),
                    givenName: "Max",
                    familyName: "Verstappen",
                    dateOfBirth: Date(timeIntervalSince1970: 844_300_800),
                    nationality: "Dutch",
                    wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Max_Verstappen")
                )
            ],
            total: 120,
            limit: 30,
            offset: 60
        )
        let repository = F1RepositoryMock(driversPageResult: .success(expectedPage))
        let sut = GetDriversPageUseCase(repository: repository)

        // When
        let page = try await sut(seasonId: seasonId, request: request)

        // Then
        #expect(page == expectedPage)
        #expect(await repository.driversPageCallCount == 1)
        #expect(await repository.receivedSeasonId == seasonId)
        #expect(await repository.receivedPageRequest == request)
    }

    @Test("GetDriversPageUseCase propagates repository errors")
    func callAsFunction_whenRepositoryFails_throwsRepositoryError() async throws {
        // Given
        let seasonId = Season.ID(rawValue: "2024")
        let request = try PageRequest(limit: 30, offset: 60)
        let expectedError = RepositoryError.sample
        let repository = F1RepositoryMock(driversPageResult: .failure(expectedError))
        let sut = GetDriversPageUseCase(repository: repository)

        // When
        let thrownError = await #expect(throws: RepositoryError.self) {
            try await sut(seasonId: seasonId, request: request)
        }

        // Then
        #expect(thrownError == expectedError)
        #expect(await repository.driversPageCallCount == 1)
        #expect(await repository.receivedSeasonId == seasonId)
        #expect(await repository.receivedPageRequest == request)
    }
}

private enum RepositoryError: Error {
    case sample
}
