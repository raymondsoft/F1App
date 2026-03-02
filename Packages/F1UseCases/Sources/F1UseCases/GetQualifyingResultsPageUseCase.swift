import F1Domain

public struct GetQualifyingResultsPageUseCase: Sendable {
    private let repository: any F1Repository

    public init(repository: any F1Repository) {
        self.repository = repository
    }

    public func callAsFunction(
        seasonId: Season.ID,
        round: Race.Round,
        request: PageRequest
    ) async throws -> Page<QualifyingResult> {
        try await repository.qualifyingResultsPage(
            seasonId: seasonId,
            round: round,
            request: request
        )
    }
}
