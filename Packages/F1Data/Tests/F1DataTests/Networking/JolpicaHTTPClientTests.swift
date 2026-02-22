import Foundation
import Testing
@testable import F1Data

@Suite(.serialized)
struct JolpicaHTTPClientTests {
    let sut: HTTPClient

    init() {
        URLProtocolStub.reset()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        sut = JolpicaHTTPClient(session: session)
    }

    @Test("Non-2xx response should throw invalidResponse error")
    func testNon2xxThrowsInvalidResponse() async {
        // Given
        let url = URL(string: "https://example.com/races")!
        URLProtocolStub.stubResponse = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        URLProtocolStub.stubData = Data("not found".utf8)

        // When
        do {
            _ = try await sut.get(url: url)
            Issue.record("Expected invalidResponse error")
        } catch let error as DataError {
            // Then
            #expect(error == .invalidResponse(statusCode: 404))
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("Empty response body should throw emptyData error")
    func testEmptyDataThrowsEmptyData() async {
        // Given
        let url = URL(string: "https://example.com/races")!
        URLProtocolStub.stubResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        URLProtocolStub.stubData = Data()

        // When
        do {
            _ = try await sut.get(url: url)
            Issue.record("Expected emptyData error")
        } catch let error as DataError {
            // Then
            #expect(error == .emptyData)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("Valid 2xx response should return data")
    func testSuccessReturnsData() async throws {
        // Given
        let url = URL(string: "https://example.com/races")!
        let expected = Data("ok".utf8)
        URLProtocolStub.stubResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        URLProtocolStub.stubData = expected

        // When
        let data = try await sut.get(url: url)

        // Then
        #expect(data == expected)
    }
}
