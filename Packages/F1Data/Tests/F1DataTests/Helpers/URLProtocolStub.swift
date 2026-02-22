import Foundation

final class URLProtocolStub: URLProtocol {
    nonisolated(unsafe) static var stubData: Data?
    nonisolated(unsafe) static var stubResponse: HTTPURLResponse?
    nonisolated(unsafe) static var stubError: Error?

    static func reset() {
        stubData = nil
        stubResponse = nil
        stubError = nil
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        if let error = Self.stubError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        if let response = Self.stubResponse {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let data = Self.stubData {
            client?.urlProtocol(self, didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
