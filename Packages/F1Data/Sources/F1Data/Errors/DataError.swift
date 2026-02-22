import Foundation

public enum DataError: Error, Equatable {
    case invalidURL
    case network(underlying: String)
    case invalidResponse(statusCode: Int)
    case emptyData
}
