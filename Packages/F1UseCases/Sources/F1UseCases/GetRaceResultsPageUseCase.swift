import F1Domain

public struct GetRaceResultsPageUseCase: Sendable {
    private let repository: any F1Repository

    public init(repository: any F1Repository) {
        self.repository = repository
    }

    public func callAsFunction(
        seasonId: Season.ID,
        round: Race.Round,
        request: PageRequest
    ) async throws -> Page<RaceResult> {
        try await repository.raceResultsPage(
            seasonId: seasonId,
            round: round,
            request: request
        )
    }
}
