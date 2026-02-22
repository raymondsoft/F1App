import Foundation
import XCTest
@testable import F1Data

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

final class JolpicaHTTPClientTests: XCTestCase {
    private var session: URLSession!
    private var client: JolpicaHTTPClient!

    override func setUp() {
        super.setUp()
        URLProtocolStub.reset()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        session = URLSession(configuration: configuration)
        client = JolpicaHTTPClient(session: session)
    }

    override func tearDown() {
        session.invalidateAndCancel()
        session = nil
        client = nil
        URLProtocolStub.reset()
        super.tearDown()
    }

    func testNon2xxThrowsInvalidResponse() async {
        let url = URL(string: "https://example.com/races")!
        URLProtocolStub.stubResponse = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        URLProtocolStub.stubData = Data("not found".utf8)

        do {
            _ = try await client.get(url: url)
            XCTFail("Expected invalidResponse error")
        } catch let error as DataError {
            XCTAssertEqual(error, .invalidResponse(statusCode: 404))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testEmptyDataThrowsEmptyData() async {
        let url = URL(string: "https://example.com/races")!
        URLProtocolStub.stubResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        URLProtocolStub.stubData = Data()

        do {
            _ = try await client.get(url: url)
            XCTFail("Expected emptyData error")
        } catch let error as DataError {
            XCTAssertEqual(error, .emptyData)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testSuccessReturnsData() async throws {
        let url = URL(string: "https://example.com/races")!
        let expected = Data("ok".utf8)
        URLProtocolStub.stubResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        URLProtocolStub.stubData = expected

        let data = try await client.get(url: url)
        XCTAssertEqual(data, expected)
    }
}
