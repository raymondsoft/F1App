import Foundation
import Testing
@testable import F1Data

@Suite
struct JolpicaAPITests {
    @Test("JolpicaAPI should call HTTPClient with expected drivers URL")
    func testDriversCallsExpectedURL() async throws {
        // Given
        let data = try loadJSONFixture(named: "drivers_2023")
        let httpClientMock = HTTPClientMock(result: .success(data))
        let sut = JolpicaAPI(httpClient: httpClientMock)

        // When
        _ = try await sut.drivers(season: "2023", limit: 20, offset: 40)

        // Then
        #expect(httpClientMock.requestedURLs == [URL(string: "https://api.jolpi.ca/ergast/f1/2023/drivers.json?limit=20&offset=40")!])
    }

    @Test("JolpicaAPI should call HTTPClient with expected constructors URL")
    func testConstructorsCallsExpectedURL() async throws {
        // Given
        let data = try loadJSONFixture(named: "constructors_2023")
        let httpClientMock = HTTPClientMock(result: .success(data))
        let sut = JolpicaAPI(httpClient: httpClientMock)

        // When
        _ = try await sut.constructors(season: "2023", limit: 20, offset: 40)

        // Then
        #expect(httpClientMock.requestedURLs == [URL(string: "https://api.jolpi.ca/ergast/f1/2023/constructors.json?limit=20&offset=40")!])
    }

    @Test("JolpicaAPI should call HTTPClient with expected race results URL")
    func testRaceResultsCallsExpectedURL() async throws {
        // Given
        let data = try loadJSONFixture(named: "race_results_2023_round1")
        let httpClientMock = HTTPClientMock(result: .success(data))
        let sut = JolpicaAPI(httpClient: httpClientMock)

        // When
        _ = try await sut.raceResults(season: "2023", round: "1", limit: 20, offset: 40)

        // Then
        #expect(httpClientMock.requestedURLs == [URL(string: "https://api.jolpi.ca/ergast/f1/2023/1/results.json?limit=20&offset=40")!])
    }

    @Test("JolpicaAPI should call HTTPClient with expected qualifying URL")
    func testQualifyingCallsExpectedURL() async throws {
        // Given
        let data = try loadJSONFixture(named: "qualifying_results_2023_round1")
        let httpClientMock = HTTPClientMock(result: .success(data))
        let sut = JolpicaAPI(httpClient: httpClientMock)

        // When
        _ = try await sut.qualifyingResults(season: "2023", round: "1", limit: 20, offset: 40)

        // Then
        #expect(httpClientMock.requestedURLs == [URL(string: "https://api.jolpi.ca/ergast/f1/2023/1/qualifying.json?limit=20&offset=40")!])
    }

    @Test("JolpicaAPI should call HTTPClient with expected driver standings URL")
    func testDriverStandingsCallsExpectedURL() async throws {
        // Given
        let data = try loadJSONFixture(named: "driver_standings_2023")
        let httpClientMock = HTTPClientMock(result: .success(data))
        let sut = JolpicaAPI(httpClient: httpClientMock)

        // When
        _ = try await sut.driverStandings(season: "2023", limit: 20, offset: 40)

        // Then
        #expect(httpClientMock.requestedURLs == [URL(string: "https://api.jolpi.ca/ergast/f1/2023/driverStandings.json?limit=20&offset=40")!])
    }

    @Test("JolpicaAPI should call HTTPClient with expected constructor standings URL")
    func testConstructorStandingsCallsExpectedURL() async throws {
        // Given
        let data = try loadJSONFixture(named: "constructor_standings_2023")
        let httpClientMock = HTTPClientMock(result: .success(data))
        let sut = JolpicaAPI(httpClient: httpClientMock)

        // When
        _ = try await sut.constructorStandings(season: "2023", limit: 20, offset: 40)

        // Then
        #expect(httpClientMock.requestedURLs == [URL(string: "https://api.jolpi.ca/ergast/f1/2023/constructorStandings.json?limit=20&offset=40")!])
    }

    @Test("JolpicaAPI should decode drivers fixture")
    func testDriversDecoding() async throws {
        // Given
        let data = try loadJSONFixture(named: "drivers_2023")
        let httpClientMock = HTTPClientMock(result: .success(data))
        let sut = JolpicaAPI(httpClient: httpClientMock)

        // When
        let response = try await sut.drivers(season: "2023", limit: 2, offset: 0)

        // Then
        #expect(response.mrData.driverTable.drivers.count == 2)
    }

    @Test("JolpicaAPI should decode race results fixture")
    func testRaceResultsDecoding() async throws {
        // Given
        let data = try loadJSONFixture(named: "race_results_2023_round1")
        let httpClientMock = HTTPClientMock(result: .success(data))
        let sut = JolpicaAPI(httpClient: httpClientMock)

        // When
        let response = try await sut.raceResults(season: "2023", round: "1", limit: 2, offset: 0)

        // Then
        #expect(response.mrData.raceTable.races[0].results.count == 2)
    }

    @Test("JolpicaAPI should propagate HTTP errors for qualifying")
    func testQualifyingPropagatesHTTPError() async {
        // Given
        let expectedError = DataError.network(underlying: "request failed")
        let httpClientMock = HTTPClientMock(result: .failure(expectedError))
        let sut = JolpicaAPI(httpClient: httpClientMock)

        // When
        do {
            _ = try await sut.qualifyingResults(season: "2023", round: "1", limit: 2, offset: 0)
            Issue.record("Expected DataError.network to be thrown")
        } catch let error as DataError {
            // Then
            #expect(error == expectedError)
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test("JolpicaAPI should throw decoding error for invalid constructor standings JSON")
    func testConstructorStandingsThrowsDecodingError() async {
        // Given
        let httpClientMock = HTTPClientMock(result: .success(Data("not-json".utf8)))
        let sut = JolpicaAPI(httpClient: httpClientMock)

        // When
        do {
            _ = try await sut.constructorStandings(season: "2023", limit: 2, offset: 0)
            Issue.record("Expected DecodingError to be thrown")
        } catch is DecodingError {
            // Then
            #expect(Bool(true))
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }
}
