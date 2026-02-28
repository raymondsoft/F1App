import Foundation
@testable import F1Domain

extension Race {
    static func fixture(
        seasonId: Season.ID = .init(rawValue: "2024"),
        round: Race.Round = .init(rawValue: "1"),
        name: String = "Bahrain Grand Prix",
        date: Date = Date(timeIntervalSince1970: 1_710_028_800),
        time: Race.Time? = .init(hour: 15, minute: 0, second: 0),
        wikipediaURL: URL? = URL(string: "https://en.wikipedia.org/wiki/2024_Bahrain_Grand_Prix"),
        circuit: Circuit = .fixture()
    ) -> Race {
        Race(
            seasonId: seasonId,
            round: round,
            name: name,
            date: date,
            time: time,
            wikipediaURL: wikipediaURL,
            circuit: circuit
        )
    }
}
