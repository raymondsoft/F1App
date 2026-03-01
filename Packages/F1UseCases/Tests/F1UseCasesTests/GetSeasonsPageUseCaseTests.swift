import F1Domain
import Foundation
import Testing
@testable import F1UseCases

@Suite
struct GetSeasonsPageUseCaseTests {
    @Test("GetSeasonsPageUseCase forwards request and returns the repository page")
    func callAsFunction_forwardsRequest_andReturnsPage() async throws {
        // Given
        let request = try PageRequest(limit: 20, offset: 40)
        let expectedPage = try Page(
            items: [
                Season(
                    id: Season.ID(rawValue: "2024"),
                    wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/2024_Formula_One_World_Championship")
                ),
                Season(
                    id: Season.ID(rawValue: "2025"),
                    wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/2025_Formula_One_World_Championship")
                )
            ],
            total: 80,
            limit: 20,
            offset: 40
        )
        let repository = F1RepositoryMock(seasonsPageResult: .success(expectedPage))
        let sut = GetSeasonsPageUseCase(repository: repository)

        // When
        let page = try await sut(request: request)

        // Then
        #expect(page == expectedPage)
        #expect(await repository.seasonsPageCallCount == 1)
        #expect(await repository.receivedPageRequest == request)
    }

    @Test("GetSeasonsPageUseCase propagates repository errors")
    func callAsFunction_whenRepositoryFails_throwsRepositoryError() async throws {
        // Given
        let request = try PageRequest(limit: 20, offset: 40)
        let expectedError = RepositoryError.sample
        let repository = F1RepositoryMock(seasonsPageResult: .failure(expectedError))
        let sut = GetSeasonsPageUseCase(repository: repository)

        // When
        let thrownError = await #expect(throws: RepositoryError.self) {
            try await sut(request: request)
        }

        // Then
        #expect(thrownError == expectedError)
        #expect(await repository.seasonsPageCallCount == 1)
        #expect(await repository.receivedPageRequest == request)
    }
}

private enum RepositoryError: Error {
    case sample
}
