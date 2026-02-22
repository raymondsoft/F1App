import Foundation
import Testing
@testable import F1Data

private func makeClient() -> JolpicaHTTPClient {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [URLProtocolStub.self]
    let session = URLSession(configuration: configuration)
    return JolpicaHTTPClient(session: session)
}

@Suite(.serialized)
struct JolpicaHTTPClientTests {
    @Test("Non-2xx response should throw invalidResponse error")
    func testNon2xxThrowsInvalidResponse() async {
        URLProtocolStub.reset()
        defer { URLProtocolStub.reset() }

        let url = URL(string: "https://example.com/races")!
        URLProtocolStub.stubResponse = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        URLProtocolStub.stubData = Data("not found".utf8)
        let client = makeClient()

        do {
            _ = try await client.get(url: url)
            Issue.record("Expected invalidResponse error")
        } catch let error as DataError {
            #expect(error == .invalidResponse(statusCode: 404))
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("Empty response body should throw emptyData error")
    func testEmptyDataThrowsEmptyData() async {
        URLProtocolStub.reset()
        defer { URLProtocolStub.reset() }

        let url = URL(string: "https://example.com/races")!
        URLProtocolStub.stubResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        URLProtocolStub.stubData = Data()
        let client = makeClient()

        do {
            _ = try await client.get(url: url)
            Issue.record("Expected emptyData error")
        } catch let error as DataError {
            #expect(error == .emptyData)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("Valid 2xx response should return data")
    func testSuccessReturnsData() async throws {
        URLProtocolStub.reset()
        defer { URLProtocolStub.reset() }

        let url = URL(string: "https://example.com/races")!
        let expected = Data("ok".utf8)
        URLProtocolStub.stubResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        URLProtocolStub.stubData = expected
        let client = makeClient()

        let data = try await client.get(url: url)
        #expect(data == expected)
    }
}
