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

    public func seasons() async throws -> [Season] {
        try await api.seasons().toDomain()
    }

    public func races(seasonId: Season.ID) async throws -> [Race] {
        try await api.races(season: seasonId.rawValue).toDomain()
    }
}
