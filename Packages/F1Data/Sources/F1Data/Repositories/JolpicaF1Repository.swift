import Foundation
import F1Domain

public struct JolpicaF1Repository: F1Repository {
    private let api: JolpicaAPI

    public init(
        baseURL: URL = URL(string: "https://api.jolpi.ca")!,
        httpClient: HTTPClient = JolpicaHTTPClient(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.api = JolpicaAPI(
            baseURL: baseURL,
            httpClient: httpClient,
            decoder: decoder
        )
    }

    init(api: JolpicaAPI) {
        self.api = api
    }

    public func seasons() async throws -> [Season] {
        try await api.seasons().toDomain()
    }

    public func seasonsPage(request: PageRequest) async throws -> Page<Season> {
        try await api.seasons(limit: request.limit, offset: request.offset).toPage()
    }

    public func races(seasonId: Season.ID) async throws -> [Race] {
        try await api.races(season: seasonId.rawValue).toDomain()
    }

    public func racesPage(seasonId: Season.ID, request: PageRequest) async throws -> Page<Race> {
        try await api.races(
            season: seasonId.rawValue,
            limit: request.limit,
            offset: request.offset
        ).toPage()
    }

    public func driversPage(seasonId: Season.ID, request: PageRequest) async throws -> Page<Driver> {
        try await api.drivers(
            season: seasonId.rawValue,
            limit: request.limit,
            offset: request.offset
        ).toPage()
    }

    public func constructorsPage(seasonId: Season.ID, request: PageRequest) async throws -> Page<Constructor> {
        try await api.constructors(
            season: seasonId.rawValue,
            limit: request.limit,
            offset: request.offset
        ).toPage()
    }

    public func raceResultsPage(
        seasonId: Season.ID,
        round: Race.Round,
        request: PageRequest
    ) async throws -> Page<RaceResult> {
        try await api.raceResults(
            season: seasonId.rawValue,
            round: round.rawValue,
            limit: request.limit,
            offset: request.offset
        ).toPage()
    }

    public func qualifyingResultsPage(
        seasonId: Season.ID,
        round: Race.Round,
        request: PageRequest
    ) async throws -> Page<QualifyingResult> {
        try await api.qualifyingResults(
            season: seasonId.rawValue,
            round: round.rawValue,
            limit: request.limit,
            offset: request.offset
        ).toPage()
    }

    public func driverStandingsPage(seasonId: Season.ID, request: PageRequest) async throws -> Page<DriverStanding> {
        try await api.driverStandings(
            season: seasonId.rawValue,
            limit: request.limit,
            offset: request.offset
        ).toPage()
    }

    public func constructorStandingsPage(seasonId: Season.ID, request: PageRequest) async throws -> Page<ConstructorStanding> {
        try await api.constructorStandings(
            season: seasonId.rawValue,
            limit: request.limit,
            offset: request.offset
        ).toPage()
    }
}
