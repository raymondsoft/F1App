import Foundation

public struct JolpicaHTTPClient: HTTPClient {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func get(url: URL) async throws -> Data {
        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw DataError.invalidResponse(statusCode: -1)
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw DataError.invalidResponse(statusCode: httpResponse.statusCode)
            }

            guard !data.isEmpty else {
                throw DataError.emptyData
            }

            return data
        } catch let error as DataError {
            throw error
        } catch {
            throw DataError.network(underlying: error.localizedDescription)
        }
    }
}
