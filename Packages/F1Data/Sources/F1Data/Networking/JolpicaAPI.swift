import Foundation

struct JolpicaAPI: Sendable {
    private let endpoint: JolpicaEndpoint
    private let httpClient: HTTPClient
    private let decoder: JSONDecoder

    init(
        baseURL: URL = URL(string: "https://api.jolpi.ca")!,
        httpClient: HTTPClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.endpoint = JolpicaEndpoint(baseURL: baseURL)
        self.httpClient = httpClient
        self.decoder = decoder
    }

    func seasons() async throws -> SeasonsResponseDTO {
        let data = try await httpClient.get(url: endpoint.seasonsURL())
        return try decoder.decode(SeasonsResponseDTO.self, from: data)
    }

    func seasons(limit: Int, offset: Int) async throws -> SeasonsResponseDTO {
        let data = try await httpClient.get(url: endpoint.seasonsURL(limit: limit, offset: offset))
        return try decoder.decode(SeasonsResponseDTO.self, from: data)
    }

    func races(season: String) async throws -> RacesResponseDTO {
        let data = try await httpClient.get(url: endpoint.racesURL(season: season))
        return try decoder.decode(RacesResponseDTO.self, from: data)
    }

    func races(season: String, limit: Int, offset: Int) async throws -> RacesResponseDTO {
        let data = try await httpClient.get(url: endpoint.racesURL(season: season, limit: limit, offset: offset))
        return try decoder.decode(RacesResponseDTO.self, from: data)
    }

    func drivers(season: String, limit: Int, offset: Int) async throws -> DriversResponseDTO {
        let data = try await httpClient.get(url: endpoint.driversURL(season: season, limit: limit, offset: offset))
        return try decoder.decode(DriversResponseDTO.self, from: data)
    }

    func constructors(season: String, limit: Int, offset: Int) async throws -> ConstructorsResponseDTO {
        let data = try await httpClient.get(url: endpoint.constructorsURL(season: season, limit: limit, offset: offset))
        return try decoder.decode(ConstructorsResponseDTO.self, from: data)
    }

    func raceResults(season: String, round: String, limit: Int, offset: Int) async throws -> RaceResultsResponseDTO {
        let data = try await httpClient.get(url: endpoint.raceResultsURL(season: season, round: round, limit: limit, offset: offset))
        return try decoder.decode(RaceResultsResponseDTO.self, from: data)
    }

    func qualifyingResults(season: String, round: String, limit: Int, offset: Int) async throws -> QualifyingResultsResponseDTO {
        let data = try await httpClient.get(url: endpoint.qualifyingResultsURL(season: season, round: round, limit: limit, offset: offset))
        return try decoder.decode(QualifyingResultsResponseDTO.self, from: data)
    }

    func driverStandings(season: String, limit: Int, offset: Int) async throws -> DriverStandingsResponseDTO {
        let data = try await httpClient.get(url: endpoint.driverStandingsURL(season: season, limit: limit, offset: offset))
        return try decoder.decode(DriverStandingsResponseDTO.self, from: data)
    }

    func constructorStandings(season: String, limit: Int, offset: Int) async throws -> ConstructorStandingsResponseDTO {
        let data = try await httpClient.get(url: endpoint.constructorStandingsURL(season: season, limit: limit, offset: offset))
        return try decoder.decode(ConstructorStandingsResponseDTO.self, from: data)
    }
}
