import F1Domain
import Foundation
import Testing
@testable import F1UseCases

@Suite
struct GetRacesForSeasonUseCaseTests {
    @Test("GetRacesForSeasonUseCase calls races with season id and returns repository races")
    func execute_callsRepositoryRacesWithSeasonId_andReturnsRaces() async throws {
        // Given
        let expectedSeasonId = Season.ID(rawValue: "2024")
        let expectedRaces = [
            Race(
                seasonId: expectedSeasonId,
                round: Race.Round(rawValue: "1"),
                name: "Bahrain Grand Prix",
                date: Date(timeIntervalSince1970: 1_709_251_200),
                time: Race.Time(hour: 15, minute: 0, second: 0, utcOffsetSeconds: 0),
                wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/2024_Bahrain_Grand_Prix"),
                circuit: Circuit(
                    id: Circuit.ID(rawValue: "bahrain"),
                    name: "Bahrain International Circuit",
                    wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit"),
                    location: Location(
                        latitude: 26.0325,
                        longitude: 50.5106,
                        locality: "Sakhir",
                        country: "Bahrain"
                    )
                )
            )
        ]
        let repository = F1RepositorySpy(racesResult: .success(expectedRaces))
        let sut = GetRacesForSeasonUseCase(repository: repository)

        // When
        let races = try await sut.execute(seasonId: expectedSeasonId)

        // Then
        #expect(races == expectedRaces)
        #expect(await repository.racesCallCount == 1)
        #expect(await repository.receivedSeasonId == expectedSeasonId)
    }

    @Test("GetRacesForSeasonUseCase propagates repository errors")
    func execute_whenRepositoryFails_throwsRepositoryError() async throws {
        // Given
        let expectedError = RepositoryError.sample
        let repository = F1RepositorySpy(racesResult: .failure(expectedError))
        let sut = GetRacesForSeasonUseCase(repository: repository)

        // When
        let thrownError = await #expect(throws: RepositoryError.self) {
            try await sut.execute(seasonId: Season.ID(rawValue: "2024"))
        }

        // Then
        #expect(thrownError == expectedError)
        #expect(await repository.racesCallCount == 1)
        #expect(await repository.receivedSeasonId == Season.ID(rawValue: "2024"))
    }
}

private enum RepositoryError: Error {
    case sample
}
