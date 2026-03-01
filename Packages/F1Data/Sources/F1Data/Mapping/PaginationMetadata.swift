import Foundation

struct PaginationMetadata {
    let total: Int?
    let limit: Int
    let offset: Int

    init(total: String?, limit: String?, offset: String?) throws {
        if let total {
            guard let parsedTotal = Int(total) else {
                throw DataError.mapping(underlying: "Invalid total: \(total)")
            }

            self.total = parsedTotal
        } else {
            self.total = nil
        }

        guard let limit else {
            throw DataError.mapping(underlying: "Missing limit")
        }

        guard let parsedLimit = Int(limit) else {
            throw DataError.mapping(underlying: "Invalid limit: \(limit)")
        }

        guard let offset else {
            throw DataError.mapping(underlying: "Missing offset")
        }

        guard let parsedOffset = Int(offset) else {
            throw DataError.mapping(underlying: "Invalid offset: \(offset)")
        }

        guard parsedLimit > 0, parsedOffset >= 0 else {
            throw DataError.mapping(underlying: "Invalid pagination metadata")
        }

        if let total = self.total, total < 0 {
            throw DataError.mapping(underlying: "Invalid pagination metadata")
        }

        self.limit = parsedLimit
        self.offset = parsedOffset
    }
}
