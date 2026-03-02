import F1Domain

actor F1RepositoryMock: F1Repository {
    private(set) var seasonsCallCount = 0
    private(set) var seasonsPageCallCount = 0
    private(set) var racesCallCount = 0
    private(set) var racesPageCallCount = 0
    private(set) var driversPageCallCount = 0
    private(set) var constructorsPageCallCount = 0
    private(set) var raceResultsPageCallCount = 0
    private(set) var qualifyingResultsPageCallCount = 0
    private(set) var driverStandingsPageCallCount = 0
    private(set) var constructorStandingsPageCallCount = 0
    private(set) var receivedSeasonId: Season.ID?
    private(set) var receivedPageRequest: PageRequest?
    private(set) var receivedRound: Race.Round?

    var seasonsResult: Result<[Season], Error>
    var seasonsPageResult: Result<Page<Season>, Error>
    var racesResult: Result<[Race], Error>
    var racesPageResult: Result<Page<Race>, Error>
    var driversPageResult: Result<Page<Driver>, Error>
    var constructorsPageResult: Result<Page<Constructor>, Error>
    var raceResultsPageResult: Result<Page<RaceResult>, Error>
    var qualifyingResultsPageResult: Result<Page<QualifyingResult>, Error>
    var driverStandingsPageResult: Result<Page<DriverStanding>, Error>
    var constructorStandingsPageResult: Result<Page<ConstructorStanding>, Error>

    init(
        seasonsResult: Result<[Season], Error> = .success([]),
        seasonsPageResult: Result<Page<Season>, Error> = .success(try! Page(items: [], total: nil, limit: 1, offset: 0)),
        racesResult: Result<[Race], Error> = .success([]),
        racesPageResult: Result<Page<Race>, Error> = .success(try! Page(items: [], total: nil, limit: 1, offset: 0)),
        driversPageResult: Result<Page<Driver>, Error> = .success(try! Page(items: [], total: nil, limit: 1, offset: 0)),
        constructorsPageResult: Result<Page<Constructor>, Error> = .success(try! Page(items: [], total: nil, limit: 1, offset: 0)),
        raceResultsPageResult: Result<Page<RaceResult>, Error> = .success(try! Page(items: [], total: nil, limit: 1, offset: 0)),
        qualifyingResultsPageResult: Result<Page<QualifyingResult>, Error> = .success(try! Page(items: [], total: nil, limit: 1, offset: 0)),
        driverStandingsPageResult: Result<Page<DriverStanding>, Error> = .success(try! Page(items: [], total: nil, limit: 1, offset: 0)),
        constructorStandingsPageResult: Result<Page<ConstructorStanding>, Error> = .success(try! Page(items: [], total: nil, limit: 1, offset: 0))
    ) {
        self.seasonsResult = seasonsResult
        self.seasonsPageResult = seasonsPageResult
        self.racesResult = racesResult
        self.racesPageResult = racesPageResult
        self.driversPageResult = driversPageResult
        self.constructorsPageResult = constructorsPageResult
        self.raceResultsPageResult = raceResultsPageResult
        self.qualifyingResultsPageResult = qualifyingResultsPageResult
        self.driverStandingsPageResult = driverStandingsPageResult
        self.constructorStandingsPageResult = constructorStandingsPageResult
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

    func driversPage(seasonId: Season.ID, request: PageRequest) async throws -> Page<Driver> {
        driversPageCallCount += 1
        receivedSeasonId = seasonId
        receivedPageRequest = request
        return try driversPageResult.get()
    }

    func constructorsPage(seasonId: Season.ID, request: PageRequest) async throws -> Page<Constructor> {
        constructorsPageCallCount += 1
        receivedSeasonId = seasonId
        receivedPageRequest = request
        return try constructorsPageResult.get()
    }

    func raceResultsPage(
        seasonId: Season.ID,
        round: Race.Round,
        request: PageRequest
    ) async throws -> Page<RaceResult> {
        raceResultsPageCallCount += 1
        receivedSeasonId = seasonId
        receivedRound = round
        receivedPageRequest = request
        return try raceResultsPageResult.get()
    }

    func qualifyingResultsPage(
        seasonId: Season.ID,
        round: Race.Round,
        request: PageRequest
    ) async throws -> Page<QualifyingResult> {
        qualifyingResultsPageCallCount += 1
        receivedSeasonId = seasonId
        receivedRound = round
        receivedPageRequest = request
        return try qualifyingResultsPageResult.get()
    }

    func driverStandingsPage(seasonId: Season.ID, request: PageRequest) async throws -> Page<DriverStanding> {
        driverStandingsPageCallCount += 1
        receivedSeasonId = seasonId
        receivedPageRequest = request
        return try driverStandingsPageResult.get()
    }

    func constructorStandingsPage(seasonId: Season.ID, request: PageRequest) async throws -> Page<ConstructorStanding> {
        constructorStandingsPageCallCount += 1
        receivedSeasonId = seasonId
        receivedPageRequest = request
        return try constructorStandingsPageResult.get()
    }
}
