public enum PaginationError: Error, Equatable, Sendable {
    case invalidLimit
    case invalidOffset
    case invalidTotal
}
