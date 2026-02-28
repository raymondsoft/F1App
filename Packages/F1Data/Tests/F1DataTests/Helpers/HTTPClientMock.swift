import Foundation
@testable import F1Data

final class HTTPClientMock: @unchecked Sendable, HTTPClient {
    enum Result {
        case success(Data)
        case failure(any Error)
    }

    private(set) var requestedURLs: [URL] = []
    private let result: Result

    init(result: Result) {
        self.result = result
    }

    func get(url: URL) async throws -> Data {
        requestedURLs.append(url)

        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}
