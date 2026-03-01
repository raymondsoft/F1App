import F1Domain

public struct GetRacesPageForSeasonUseCase: Sendable {
    private let repository: any F1Repository

    public init(repository: any F1Repository) {
        self.repository = repository
    }

    public func callAsFunction(
        seasonId: Season.ID,
        request: PageRequest
    ) async throws -> Page<Race> {
        try await repository.racesPage(seasonId: seasonId, request: request)
    }
}
