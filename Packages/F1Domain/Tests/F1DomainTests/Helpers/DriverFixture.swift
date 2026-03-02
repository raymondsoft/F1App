import Foundation
@testable import F1Domain

extension Driver {
    static func fixture(
        id: Driver.ID = .init(rawValue: "max_verstappen"),
        givenName: String = "Max",
        familyName: String = "Verstappen",
        dateOfBirth: Date? = Date(timeIntervalSince1970: 915_148_800),
        nationality: String = "Dutch",
        wikipediaURL: URL? = URL(string: "https://en.wikipedia.org/wiki/Max_Verstappen")
    ) -> Driver {
        Driver(
            id: id,
            givenName: givenName,
            familyName: familyName,
            dateOfBirth: dateOfBirth,
            nationality: nationality,
            wikipediaURL: wikipediaURL
        )
    }
}
