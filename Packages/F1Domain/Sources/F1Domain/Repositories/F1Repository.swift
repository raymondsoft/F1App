public protocol F1Repository: Sendable {
    func seasons() async throws -> [Season]
    func races(seasonId: Season.ID) async throws -> [Race]
}
