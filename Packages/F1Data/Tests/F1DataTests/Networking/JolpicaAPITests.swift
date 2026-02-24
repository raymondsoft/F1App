import Foundation
import Testing
@testable import F1Data

@Suite
struct JolpicaAPITests {
    @Test("Seasons should call HTTPClient with the expected seasons URL")
    func testSeasonsCallsExpectedURL() async throws {
        // Given
        let seasonsData = try loadJSONFixture(named: "seasons")
        let httpClientSpy = HTTPClientSpy(result: .success(seasonsData))
        let sut = JolpicaAPI(httpClient: httpClientSpy)
        let expectedURL = URL(string: "https://api.jolpi.ca/api/f1/seasons.json")!

        // When
        _ = try await sut.seasons()

        // Then
        #expect(httpClientSpy.requestedURLs == [expectedURL])
    }

    @Test("Races should call HTTPClient with the expected races URL for season")
    func testRacesCallsExpectedURL() async throws {
        // Given
        let racesData = try loadJSONFixture(named: "races_2023")
        let httpClientSpy = HTTPClientSpy(result: .success(racesData))
        let sut = JolpicaAPI(httpClient: httpClientSpy)
        let expectedURL = URL(string: "https://api.jolpi.ca/api/f1/2023/races.json")!

        // When
        _ = try await sut.races(season: "2023")

        // Then
        #expect(httpClientSpy.requestedURLs == [expectedURL])
    }

    @Test("Seasons should decode SeasonsResponseDTO when HTTPClient returns seasons fixture data")
    func testSeasonsDecodesFixtureData() async throws {
        // Given
        let seasonsData = try loadJSONFixture(named: "seasons")
        let httpClientSpy = HTTPClientSpy(result: .success(seasonsData))
        let sut = JolpicaAPI(httpClient: httpClientSpy)

        // When
        let response = try await sut.seasons()

        // Then
        #expect(response.mrData.seasonTable.seasons.count == 3)
        #expect(response.mrData.seasonTable.seasons[0].season == "2023")
    }

    @Test("Races should decode RacesResponseDTO when HTTPClient returns races fixture data")
    func testRacesDecodesFixtureData() async throws {
        // Given
        let racesData = try loadJSONFixture(named: "races_2023")
        let httpClientSpy = HTTPClientSpy(result: .success(racesData))
        let sut = JolpicaAPI(httpClient: httpClientSpy)

        // When
        let response = try await sut.races(season: "2023")

        // Then
        #expect(response.mrData.raceTable.season == "2023")
        #expect(response.mrData.raceTable.races.count == 2)
    }

    @Test("Seasons should propagate HTTPClient errors")
    func testSeasonsPropagatesHTTPClientErrors() async {
        // Given
        let expectedError = DataError.network(underlying: "request failed")
        let httpClientSpy = HTTPClientSpy(result: .failure(expectedError))
        let sut = JolpicaAPI(httpClient: httpClientSpy)

        // When
        do {
            _ = try await sut.seasons()
            Issue.record("Expected DataError.network to be thrown")
        } catch let error as DataError {
            // Then
            #expect(error == expectedError)
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test("Seasons should throw decoding error for invalid JSON")
    func testSeasonsThrowsDecodingErrorForInvalidJSON() async {
        // Given
        let invalidJSONData = Data("not-json".utf8)
        let httpClientSpy = HTTPClientSpy(result: .success(invalidJSONData))
        let sut = JolpicaAPI(httpClient: httpClientSpy)

        // When
        do {
            _ = try await sut.seasons()
            Issue.record("Expected DecodingError to be thrown")
        } catch is DecodingError {
            // Then
            #expect(Bool(true))
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }
}
