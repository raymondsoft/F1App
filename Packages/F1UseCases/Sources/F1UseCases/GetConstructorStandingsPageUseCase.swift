import F1Domain

public struct GetConstructorStandingsPageUseCase: Sendable {
    private let repository: any F1Repository

    public init(repository: any F1Repository) {
        self.repository = repository
    }

    public func callAsFunction(
        seasonId: Season.ID,
        request: PageRequest
    ) async throws -> Page<ConstructorStanding> {
        try await repository.constructorStandingsPage(seasonId: seasonId, request: request)
    }
}
