import F1Domain

public struct GetDriversPageUseCase: Sendable {
    private let repository: any F1Repository

    public init(repository: any F1Repository) {
        self.repository = repository
    }

    public func callAsFunction(
        seasonId: Season.ID,
        request: PageRequest
    ) async throws -> Page<Driver> {
        try await repository.driversPage(seasonId: seasonId, request: request)
    }
}
