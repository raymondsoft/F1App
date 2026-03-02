import Foundation
@testable import F1Domain

extension Constructor {
    static func fixture(
        id: Constructor.ID = .init(rawValue: "red_bull"),
        name: String = "Red Bull",
        nationality: String = "Austrian",
        wikipediaURL: URL? = URL(string: "https://en.wikipedia.org/wiki/Red_Bull_Racing")
    ) -> Constructor {
        Constructor(
            id: id,
            name: name,
            nationality: nationality,
            wikipediaURL: wikipediaURL
        )
    }
}
