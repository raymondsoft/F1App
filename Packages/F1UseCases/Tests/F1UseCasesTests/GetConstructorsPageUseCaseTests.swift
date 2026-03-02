import F1Domain
import Foundation
import Testing
@testable import F1UseCases

@Suite
struct GetConstructorsPageUseCaseTests {
    @Test("GetConstructorsPageUseCase forwards season id and request and returns the repository page")
    func callAsFunction_forwardsSeasonIdAndRequest_andReturnsPage() async throws {
        // Given
        let seasonId = Season.ID(rawValue: "2024")
        let request = try PageRequest(limit: 15, offset: 30)
        let expectedPage = try Page(
            items: [
                Constructor(
                    id: Constructor.ID(rawValue: "red_bull"),
                    name: "Red Bull",
                    nationality: "Austrian",
                    wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Red_Bull_Racing")
                )
            ],
            total: 30,
            limit: 15,
            offset: 30
        )
        let repository = F1RepositoryMock(constructorsPageResult: .success(expectedPage))
        let sut = GetConstructorsPageUseCase(repository: repository)

        // When
        let page = try await sut(seasonId: seasonId, request: request)

        // Then
        #expect(page == expectedPage)
        #expect(await repository.constructorsPageCallCount == 1)
        #expect(await repository.receivedSeasonId == seasonId)
        #expect(await repository.receivedPageRequest == request)
    }

    @Test("GetConstructorsPageUseCase propagates repository errors")
    func callAsFunction_whenRepositoryFails_throwsRepositoryError() async throws {
        // Given
        let seasonId = Season.ID(rawValue: "2024")
        let request = try PageRequest(limit: 15, offset: 30)
        let expectedError = RepositoryError.sample
        let repository = F1RepositoryMock(constructorsPageResult: .failure(expectedError))
        let sut = GetConstructorsPageUseCase(repository: repository)

        // When
        let thrownError = await #expect(throws: RepositoryError.self) {
            try await sut(seasonId: seasonId, request: request)
        }

        // Then
        #expect(thrownError == expectedError)
        #expect(await repository.constructorsPageCallCount == 1)
        #expect(await repository.receivedSeasonId == seasonId)
        #expect(await repository.receivedPageRequest == request)
    }
}

private enum RepositoryError: Error {
    case sample
}
