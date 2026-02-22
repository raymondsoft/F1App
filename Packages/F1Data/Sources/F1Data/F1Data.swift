import Foundation

public enum DataError: Error, Equatable {
    case invalidURL
    case network(underlying: String)
    case invalidResponse(statusCode: Int)
    case emptyData
}

public struct JolpicaHTTPClient {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func get(url: URL) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            let task = session.dataTask(with: url) { data, response, error in
                if let error {
                    continuation.resume(throwing: DataError.network(underlying: error.localizedDescription))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    continuation.resume(throwing: DataError.invalidResponse(statusCode: -1))
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    continuation.resume(throwing: DataError.invalidResponse(statusCode: httpResponse.statusCode))
                    return
                }

                guard let data, !data.isEmpty else {
                    continuation.resume(throwing: DataError.emptyData)
                    return
                }

                continuation.resume(returning: data)
            }

            task.resume()
        }
    }
}
