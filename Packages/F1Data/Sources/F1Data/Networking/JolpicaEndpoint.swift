import Foundation

struct JolpicaEndpoint: Sendable {
    let baseURL: URL

    init(baseURL: URL = URL(string: "https://api.jolpi.ca")!) {
        self.baseURL = baseURL
    }

    func seasonsURL() -> URL {
        seasonsURL(limit: nil, offset: nil)
    }

    func seasonsURL(limit: Int?, offset: Int?) -> URL {
        makeURL(
            pathComponents: [
                "ergast",
                "f1",
                "seasons.json"
            ],
            limit: limit,
            offset: offset
        )
    }

    func racesURL(season: String) -> URL {
        racesURL(season: season, limit: nil, offset: nil)
    }

    func racesURL(season: String, limit: Int?, offset: Int?) -> URL {
        makeURL(
            pathComponents: [
                "ergast",
                "f1",
                season,
                "races.json"
            ],
            limit: limit,
            offset: offset
        )
    }

    private func makeURL(
        pathComponents: [String],
        limit: Int?,
        offset: Int?
    ) -> URL {
        let pathURL = pathComponents.reduce(baseURL) { partialURL, component in
            partialURL.appendingPathComponent(component)
        }

        guard limit != nil || offset != nil else {
            return pathURL
        }

        var components = URLComponents(url: pathURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            limit.map { URLQueryItem(name: "limit", value: String($0)) },
            offset.map { URLQueryItem(name: "offset", value: String($0)) }
        ].compactMap { $0 }

        return components.url!
    }
}
