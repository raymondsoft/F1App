import Foundation

public struct RaceResult: Hashable, Sendable {
    public let seasonId: Season.ID
    public let round: Race.Round
    public let raceName: String
    public let date: Date
    public let time: Race.Time?
    public let driver: Driver
    public let constructor: Constructor
    public let grid: Int?
    public let position: Int?
    public let positionText: String
    public let points: Double
    public let laps: Int?
    public let status: String
    public let timeOrRetired: String?

    public init(
        seasonId: Season.ID,
        round: Race.Round,
        raceName: String,
        date: Date,
        time: Race.Time?,
        driver: Driver,
        constructor: Constructor,
        grid: Int?,
        position: Int?,
        positionText: String,
        points: Double,
        laps: Int?,
        status: String,
        timeOrRetired: String?
    ) {
        self.seasonId = seasonId
        self.round = round
        self.raceName = raceName
        self.date = date
        self.time = time
        self.driver = driver
        self.constructor = constructor
        self.grid = grid
        self.position = position
        self.positionText = positionText
        self.points = points
        self.laps = laps
        self.status = status
        self.timeOrRetired = timeOrRetired
    }
}
