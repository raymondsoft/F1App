import F1Domain

public struct GetSeasonsUseCase: Sendable {
    public let repository: any F1Repository

    public init(repository: any F1Repository) {
        self.repository = repository
    }

    public func execute() async throws -> [Season] {
        try await repository.seasons()
    }
}
