import F1Domain

actor F1RepositoryMock: F1Repository {
    private(set) var seasonsCallCount = 0
    private(set) var seasonsPageCallCount = 0
    private(set) var racesCallCount = 0
    private(set) var racesPageCallCount = 0
    private(set) var receivedSeasonId: Season.ID?
    private(set) var receivedPageRequest: PageRequest?

    var seasonsResult: Result<[Season], Error>
    var seasonsPageResult: Result<Page<Season>, Error>
    var racesResult: Result<[Race], Error>
    var racesPageResult: Result<Page<Race>, Error>

    init(
        seasonsResult: Result<[Season], Error> = .success([]),
        seasonsPageResult: Result<Page<Season>, Error> = .success(try! Page(items: [], total: nil, limit: 1, offset: 0)),
        racesResult: Result<[Race], Error> = .success([]),
        racesPageResult: Result<Page<Race>, Error> = .success(try! Page(items: [], total: nil, limit: 1, offset: 0))
    ) {
        self.seasonsResult = seasonsResult
        self.seasonsPageResult = seasonsPageResult
        self.racesResult = racesResult
        self.racesPageResult = racesPageResult
    }

    func seasons() async throws -> [Season] {
        seasonsCallCount += 1
        return try seasonsResult.get()
    }

    func seasonsPage(request: PageRequest) async throws -> Page<Season> {
        seasonsPageCallCount += 1
        receivedPageRequest = request
        return try seasonsPageResult.get()
    }

    func races(seasonId: Season.ID) async throws -> [Race] {
        racesCallCount += 1
        receivedSeasonId = seasonId
        return try racesResult.get()
    }

    func racesPage(seasonId: Season.ID, request: PageRequest) async throws -> Page<Race> {
        racesPageCallCount += 1
        receivedSeasonId = seasonId
        receivedPageRequest = request
        return try racesPageResult.get()
    }
}
