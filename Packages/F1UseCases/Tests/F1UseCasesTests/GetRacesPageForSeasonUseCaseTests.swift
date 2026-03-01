import F1Domain
import Foundation
import Testing
@testable import F1UseCases

@Suite
struct GetRacesPageForSeasonUseCaseTests {
    @Test("GetRacesPageForSeasonUseCase forwards season id and request and returns the repository page")
    func callAsFunction_forwardsSeasonIdAndRequest_andReturnsPage() async throws {
        // Given
        let seasonId = Season.ID(rawValue: "2024")
        let request = try PageRequest(limit: 10, offset: 20)
        let expectedPage = try Page(
            items: [
                Race(
                    seasonId: seasonId,
                    round: Race.Round(rawValue: "3"),
                    name: "Australian Grand Prix",
                    date: Date(timeIntervalSince1970: 1_710_662_400),
                    time: Race.Time(hour: 4, minute: 0, second: 0, utcOffsetSeconds: 0),
                    wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/2024_Australian_Grand_Prix"),
                    circuit: Circuit(
                        id: Circuit.ID(rawValue: "albert_park"),
                        name: "Albert Park Grand Prix Circuit",
                        wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Albert_Park_Circuit"),
                        location: Location(
                            latitude: -37.8497,
                            longitude: 144.968,
                            locality: "Melbourne",
                            country: "Australia"
                        )
                    )
                )
            ],
            total: 24,
            limit: 10,
            offset: 20
        )
        let repository = F1RepositoryMock(racesPageResult: .success(expectedPage))
        let sut = GetRacesPageForSeasonUseCase(repository: repository)

        // When
        let page = try await sut(seasonId: seasonId, request: request)

        // Then
        #expect(page == expectedPage)
        #expect(await repository.racesPageCallCount == 1)
        #expect(await repository.receivedSeasonId == seasonId)
        #expect(await repository.receivedPageRequest == request)
    }

    @Test("GetRacesPageForSeasonUseCase propagates repository errors")
    func callAsFunction_whenRepositoryFails_throwsRepositoryError() async throws {
        // Given
        let seasonId = Season.ID(rawValue: "2024")
        let request = try PageRequest(limit: 10, offset: 20)
        let expectedError = RepositoryError.sample
        let repository = F1RepositoryMock(racesPageResult: .failure(expectedError))
        let sut = GetRacesPageForSeasonUseCase(repository: repository)

        // When
        let thrownError = await #expect(throws: RepositoryError.self) {
            try await sut(seasonId: seasonId, request: request)
        }

        // Then
        #expect(thrownError == expectedError)
        #expect(await repository.racesPageCallCount == 1)
        #expect(await repository.receivedSeasonId == seasonId)
        #expect(await repository.receivedPageRequest == request)
    }
}

private enum RepositoryError: Error {
    case sample
}
