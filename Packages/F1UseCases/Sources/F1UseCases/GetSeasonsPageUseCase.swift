import F1Domain

public struct GetSeasonsPageUseCase: Sendable {
    private let repository: any F1Repository

    public init(repository: any F1Repository) {
        self.repository = repository
    }

    public func callAsFunction(request: PageRequest) async throws -> Page<Season> {
        try await repository.seasonsPage(request: request)
    }
}
