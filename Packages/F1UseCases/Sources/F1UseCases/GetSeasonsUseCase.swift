import F1Domain

public struct GetSeasonsUseCase: Sendable {
    private let repository: any F1Repository

    public init(repository: any F1Repository) {
        self.repository = repository
    }

    public func callAsFunction() async throws -> [Season] {
        try await repository.seasons()
    }
}
