public struct QualifyingResult: Hashable, Sendable {
    public let seasonId: Season.ID
    public let round: Race.Round
    public let driver: Driver
    public let constructor: Constructor
    public let position: Int?
    public let q1: QualifyingLapTime?
    public let q2: QualifyingLapTime?
    public let q3: QualifyingLapTime?

    public init(
        seasonId: Season.ID,
        round: Race.Round,
        driver: Driver,
        constructor: Constructor,
        position: Int?,
        q1: QualifyingLapTime?,
        q2: QualifyingLapTime?,
        q3: QualifyingLapTime?
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
