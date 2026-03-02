import F1Domain

public struct GetDriverStandingsPageUseCase: Sendable {
    private let repository: any F1Repository

    public init(repository: any F1Repository) {
        self.repository = repository
    }

    public func callAsFunction(
        seasonId: Season.ID,
        request: PageRequest
    ) async throws -> Page<DriverStanding> {
        try await repository.driverStandingsPage(seasonId: seasonId, request: request)
    }
}
