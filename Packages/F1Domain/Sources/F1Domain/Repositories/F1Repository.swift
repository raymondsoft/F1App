public protocol F1Repository: Sendable {
    func seasons() async throws -> [Season]
    func seasonsPage(request: PageRequest) async throws -> Page<Season>
    func races(seasonId: Season.ID) async throws -> [Race]
    func racesPage(seasonId: Season.ID, request: PageRequest) async throws -> Page<Race>
    func driversPage(seasonId: Season.ID, request: PageRequest) async throws -> Page<Driver>
    func constructorsPage(seasonId: Season.ID, request: PageRequest) async throws -> Page<Constructor>
    func raceResultsPage(
        seasonId: Season.ID,
        round: Race.Round,
        request: PageRequest
    ) async throws -> Page<RaceResult>
    func qualifyingResultsPage(
        seasonId: Season.ID,
        round: Race.Round,
        request: PageRequest
    ) async throws -> Page<QualifyingResult>
    func driverStandingsPage(seasonId: Season.ID, request: PageRequest) async throws -> Page<DriverStanding>
    func constructorStandingsPage(seasonId: Season.ID, request: PageRequest) async throws -> Page<ConstructorStanding>
}
