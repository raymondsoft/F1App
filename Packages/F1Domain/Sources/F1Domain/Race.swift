import Foundation

public struct Race: Hashable, Sendable {
    public struct Round: RawRepresentable, Hashable, Sendable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    public struct Time: Hashable, Sendable {
        public let hour: Int
        public let minute: Int
        public let second: Int
        public let utcOffsetSeconds: Int

        public init(
            hour: Int,
            minute: Int,
            second: Int,
            utcOffsetSeconds: Int = 0
        ) {
            self.hour = hour
            self.minute = minute
            self.second = second
            self.utcOffsetSeconds = utcOffsetSeconds
        }
    }

    public let seasonId: Season.ID
    public let round: Round
    public let name: String
    public let date: Date
    public let time: Time?
    public let wikipediaURL: URL?
    public let circuit: Circuit

    public init(
        seasonId: Season.ID,
        round: Round,
        name: String,
        date: Date,
        time: Time?,
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
