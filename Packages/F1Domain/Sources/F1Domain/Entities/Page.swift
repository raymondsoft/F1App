public struct Page<Element>: Sendable where Element: Sendable {
    public let items: [Element]
    public let total: Int?
    public let limit: Int
    public let offset: Int

    public var hasMore: Bool {
        if let total {
            return offset + items.count < total
        }

        return items.count == limit
    }

    public init(
        items: [Element],
        total: Int?,
        limit: Int,
        offset: Int
    ) throws {
        guard limit > 0 else {
            throw PaginationError.invalidLimit
        }

        guard offset >= 0 else {
            throw PaginationError.invalidOffset
        }

        if let total {
            guard total >= 0 else {
                throw PaginationError.invalidTotal
            }
        }

        self.items = items
        self.total = total
        self.limit = limit
        self.offset = offset
    }
}

extension Page: Equatable where Element: Equatable {}
extension Page: Hashable where Element: Hashable {}
