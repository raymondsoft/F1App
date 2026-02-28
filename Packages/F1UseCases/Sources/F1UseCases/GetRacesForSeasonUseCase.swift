import F1Domain

public struct GetRacesForSeasonUseCase: Sendable {
    private let repository: any F1Repository

    public init(repository: any F1Repository) {
        self.repository = repository
    }

    public func callAsFunction(seasonId: Season.ID) async throws -> [Race] {
        try await repository.races(seasonId: seasonId)
    }
}
