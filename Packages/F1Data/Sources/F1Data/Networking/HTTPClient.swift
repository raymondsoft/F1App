import Foundation

public protocol HTTPClient {
    func get(url: URL) async throws -> Data
}
