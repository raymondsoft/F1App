import F1Domain

actor F1RepositoryMock: F1Repository {
    private(set) var seasonsCallCount = 0
    private(set) var racesCallCount = 0
    private(set) var receivedSeasonId: Season.ID?

    var seasonsResult: Result<[Season], Error>
    var racesResult: Result<[Race], Error>

    init(
        seasonsResult: Result<[Season], Error> = .success([]),
        racesResult: Result<[Race], Error> = .success([])
    ) {
        self.seasonsResult = seasonsResult
        self.racesResult = racesResult
    }

    func seasons() async throws -> [Season] {
        seasonsCallCount += 1
        return try seasonsResult.get()
    }

    func races(seasonId: Season.ID) async throws -> [Race] {
        racesCallCount += 1
        receivedSeasonId = seasonId
        return try racesResult.get()
    }
}
