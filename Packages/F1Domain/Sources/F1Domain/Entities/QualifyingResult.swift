public struct QualifyingResult: Hashable, Sendable {
    public let seasonId: Season.ID
    public let round: Race.Round
    public let driver: Driver
    public let constructor: Constructor
    public let position: Int?
    public let q1: String?
    public let q2: String?
    public let q3: String?

    public init(
        seasonId: Season.ID,
        round: Race.Round,
        driver: Driver,
        constructor: Constructor,
        position: Int?,
        q1: String?,
        q2: String?,
        q3: String?
    ) {
        self.seasonId = seasonId
        self.round = round
        self.driver = driver
        self.constructor = constructor
        self.position = position
        self.q1 = q1
        self.q2 = q2
        self.q3 = q3
    }
}
