import Foundation
@testable import F1Domain

extension Season {
    static func fixture(
        id: Season.ID = .init(rawValue: "2024"),
        wikipediaURL: URL? = URL(string: "https://en.wikipedia.org/wiki/2024_Formula_One_World_Championship")
    ) -> Season {
        Season(
            id: id,
            wikipediaURL: wikipediaURL
        )
    }
}
