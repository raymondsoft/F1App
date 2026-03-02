public struct ConstructorStanding: Hashable, Sendable {
    public let seasonId: Season.ID
    public let position: Int?
    public let points: Double
    public let wins: Int
    public let constructor: Constructor

    public init(
        seasonId: Season.ID,
        position: Int?,
        points: Double,
        wins: Int,
        constructor: Constructor
    ) {
        self.seasonId = seasonId
        self.position = position
        self.points = points
        self.wins = wins
        self.constructor = constructor
    }
}
