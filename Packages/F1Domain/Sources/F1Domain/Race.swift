import Foundation

public struct Race: Hashable, Sendable {
    public let seasonId: Season.ID
    public let round: String
    public let name: String
    public let date: Date
    public let time: String?
    public let wikipediaURL: URL?
    public let circuit: Circuit

    public init(
        seasonId: Season.ID,
        round: String,
        name: String,
        date: Date,
        time: String?,
        wikipediaURL: URL?,
        circuit: Circuit
    ) {
        self.seasonId = seasonId
        self.round = round
        self.name = name
        self.date = date
        self.time = time
        self.wikipediaURL = wikipediaURL
        self.circuit = circuit
    }
}
