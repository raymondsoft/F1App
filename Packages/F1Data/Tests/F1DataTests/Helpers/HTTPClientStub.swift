import Foundation
@testable import F1Data

final class HTTPClientStub: @unchecked Sendable, HTTPClient {
    enum Response {
        case success(Data)
        case failure(any Error)
    }

    private let responses: [URL: Response]

    init(responses: [URL: Response]) {
        self.responses = responses
    }

    func get(url: URL) async throws -> Data {
        guard let response = responses[url] else {
            throw DataError.invalidURL
        }

        switch response {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}
