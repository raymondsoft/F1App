public protocol F1Repository: Sendable {
    func seasons() async throws -> [Season]
    func seasonsPage(request: PageRequest) async throws -> Page<Season>
    func races(seasonId: Season.ID) async throws -> [Race]
    func racesPage(seasonId: Season.ID, request: PageRequest) async throws -> Page<Race>
}
