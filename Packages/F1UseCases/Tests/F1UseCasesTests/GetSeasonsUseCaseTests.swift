import F1Domain
import Foundation
import Testing
@testable import F1UseCases

@Suite
struct GetSeasonsUseCaseTests {
    @Test("GetSeasonsUseCase calls seasons once and returns repository seasons")
    func callAsFunction_callsRepositorySeasonsOnce_andReturnsSeasons() async throws {
        // Given
        let expectedSeasons = [
            Season(
                id: Season.ID(rawValue: "2024"),
                wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/2024_Formula_One_World_Championship")
            ),
            Season(
                id: Season.ID(rawValue: "2025"),
                wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/2025_Formula_One_World_Championship")
            )
        ]
        let repository = F1RepositoryMock(seasonsResult: .success(expectedSeasons))
        let sut = GetSeasonsUseCase(repository: repository)

        // When
        let seasons = try await sut()

        // Then
        #expect(seasons == expectedSeasons)
        #expect(await repository.seasonsCallCount == 1)
    }

    @Test("GetSeasonsUseCase propagates repository errors")
    func callAsFunction_whenRepositoryFails_throwsRepositoryError() async throws {
        // Given
        let expectedError = RepositoryError.sample
        let repository = F1RepositoryMock(seasonsResult: .failure(expectedError))
        let sut = GetSeasonsUseCase(repository: repository)

        // When
        let thrownError = await #expect(throws: RepositoryError.self) {
            try await sut()
        }

        // Then
        #expect(thrownError == expectedError)
        #expect(await repository.seasonsCallCount == 1)
    }
}

private enum RepositoryError: Error {
    case sample
}
