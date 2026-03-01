public struct PageRequest: Hashable, Sendable {
    public let limit: Int
    public let offset: Int

    public init(
        limit: Int,
        offset: Int
    ) throws {
        guard limit > 0 else {
            throw PaginationError.invalidLimit
        }

        guard offset >= 0 else {
            throw PaginationError.invalidOffset
        }

        self.limit = limit
        self.offset = offset
    }
}
