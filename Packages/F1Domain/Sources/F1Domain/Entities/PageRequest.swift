public struct PageRequest: Hashable, Sendable {
    public let limit: Int
    public let offset: Int

    public init(
        limit: Int,
        offset: Int
    ) {
        self.limit = limit
        self.offset = offset
    }
}
