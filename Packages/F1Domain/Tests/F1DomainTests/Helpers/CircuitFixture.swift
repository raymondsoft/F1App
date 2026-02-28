import Foundation
@testable import F1Domain

extension Circuit {
    static func fixture(
        id: Circuit.ID = .init(rawValue: "bahrain"),
        name: String = "Bahrain International Circuit",
        wikipediaURL: URL? = URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit"),
        location: Location = .fixture()
    ) -> Circuit {
        Circuit(
            id: id,
            name: name,
            wikipediaURL: wikipediaURL,
            location: location
        )
    }
}
