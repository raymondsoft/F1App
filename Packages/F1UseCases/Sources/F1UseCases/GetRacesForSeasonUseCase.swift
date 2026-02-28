import F1Domain

public struct GetRacesForSeasonUseCase: Sendable {
    public let repository: any F1Repository

    public init(repository: any F1Repository) {
        self.repository = repository
    }

    public func execute(seasonId: Season.ID) async throws -> [Race] {
        try await repository.races(seasonId: seasonId)
    }
}
