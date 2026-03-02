import F1Domain

public struct GetConstructorsPageUseCase: Sendable {
    private let repository: any F1Repository

    public init(repository: any F1Repository) {
        self.repository = repository
    }

    public func callAsFunction(
        seasonId: Season.ID,
        request: PageRequest
    ) async throws -> Page<Constructor> {
        try await repository.constructorsPage(seasonId: seasonId, request: request)
    }
}
