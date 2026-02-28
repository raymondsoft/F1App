import Foundation

struct JolpicaEndpoint: Sendable {
    let baseURL: URL

    init(baseURL: URL = URL(string: "https://api.jolpi.ca")!) {
        self.baseURL = baseURL
    }

    func seasonsURL() -> URL {
        baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("f1")
            .appendingPathComponent("seasons.json")
    }

    func racesURL(season: String) -> URL {
        baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("f1")
            .appendingPathComponent(season)
            .appendingPathComponent("races.json")
    }
}
