public struct DriverStanding: Hashable, Sendable {
    public let seasonId: Season.ID
    public let position: Int?
    public let points: Double
    public let wins: Int
    public let driver: Driver
    public let constructors: [Constructor]

    public init(
        seasonId: Season.ID,
        position: Int?,
        points: Double,
        wins: Int,
        driver: Driver,
        constructors: [Constructor]
    ) {
        self.seasonId = seasonId
        self.position = position
        self.points = points
        self.wins = wins
        self.driver = driver
        self.constructors = constructors
    }
}
