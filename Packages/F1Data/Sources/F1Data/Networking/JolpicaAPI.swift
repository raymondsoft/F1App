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
        let data = try await httpClient.get(
            url: endpoint.seasonsURL(limit: limit, offset: offset)
        )
        return try decoder.decode(SeasonsResponseDTO.self, from: data)
    }

    func races(season: String) async throws -> RacesResponseDTO {
        let data = try await httpClient.get(url: endpoint.racesURL(season: season))
        return try decoder.decode(RacesResponseDTO.self, from: data)
    }

    func races(season: String, limit: Int, offset: Int) async throws -> RacesResponseDTO {
        let data = try await httpClient.get(
            url: endpoint.racesURL(season: season, limit: limit, offset: offset)
        )
        return try decoder.decode(RacesResponseDTO.self, from: data)
    }
}
