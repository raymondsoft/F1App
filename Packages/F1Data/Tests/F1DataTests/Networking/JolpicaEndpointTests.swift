import Foundation
import Testing
@testable import F1Data

@Suite
struct JolpicaEndpointTests {
    @Test("JolpicaEndpoint should build seasons URL with default base")
    func testSeasonsURL() {
        // Given
        let sut = JolpicaEndpoint()

        // When
        let url = sut.seasonsURL()

        // Then
        #expect(url == URL(string: "https://api.jolpi.ca/ergast/f1/seasons.json")!)
    }

    @Test("JolpicaEndpoint should build races URL for a season")
    func testRacesURL() {
        // Given
        let sut = JolpicaEndpoint()

        // When
        let url = sut.racesURL(season: "2023")

        // Then
        #expect(url == URL(string: "https://api.jolpi.ca/ergast/f1/2023/races.json")!)
    }

    @Test("JolpicaEndpoint should preserve custom base path segments")
    func testCustomBaseURLWithPath() {
        // Given
        let sut = JolpicaEndpoint(baseURL: URL(string: "https://example.com/proxy/v1")!)

        // When
        let seasonsURL = sut.seasonsURL()
        let racesURL = sut.racesURL(season: "current")

        // Then
        #expect(seasonsURL == URL(string: "https://example.com/proxy/v1/ergast/f1/seasons.json")!)
        #expect(racesURL == URL(string: "https://example.com/proxy/v1/ergast/f1/current/races.json")!)
    }

    @Test("JolpicaEndpoint should build drivers URL with pagination")
    func testDriversURL() {
        // Given
        let sut = JolpicaEndpoint()

        // When
        let url = sut.driversURL(season: "2023", limit: 20, offset: 40)

        // Then
        #expect(url == URL(string: "https://api.jolpi.ca/ergast/f1/2023/drivers.json?limit=20&offset=40")!)
    }

    @Test("JolpicaEndpoint should build constructors URL with pagination")
    func testConstructorsURL() {
        // Given
        let sut = JolpicaEndpoint()

        // When
        let url = sut.constructorsURL(season: "2023", limit: 20, offset: 40)

        // Then
        #expect(url == URL(string: "https://api.jolpi.ca/ergast/f1/2023/constructors.json?limit=20&offset=40")!)
    }

    @Test("JolpicaEndpoint should build race results URL with pagination")
    func testRaceResultsURL() {
        // Given
        let sut = JolpicaEndpoint()

        // When
        let url = sut.raceResultsURL(season: "2023", round: "1", limit: 20, offset: 40)

        // Then
        #expect(url == URL(string: "https://api.jolpi.ca/ergast/f1/2023/1/results.json?limit=20&offset=40")!)
    }

    @Test("JolpicaEndpoint should build qualifying results URL with pagination")
    func testQualifyingResultsURL() {
        // Given
        let sut = JolpicaEndpoint()

        // When
        let url = sut.qualifyingResultsURL(season: "2023", round: "1", limit: 20, offset: 40)

        // Then
        #expect(url == URL(string: "https://api.jolpi.ca/ergast/f1/2023/1/qualifying.json?limit=20&offset=40")!)
    }

    @Test("JolpicaEndpoint should build driver standings URL with pagination")
    func testDriverStandingsURL() {
        // Given
        let sut = JolpicaEndpoint()

        // When
        let url = sut.driverStandingsURL(season: "2023", limit: 20, offset: 40)

        // Then
        #expect(url == URL(string: "https://api.jolpi.ca/ergast/f1/2023/driverStandings.json?limit=20&offset=40")!)
    }

    @Test("JolpicaEndpoint should build constructor standings URL with pagination")
    func testConstructorStandingsURL() {
        // Given
        let sut = JolpicaEndpoint()

        // When
        let url = sut.constructorStandingsURL(season: "2023", limit: 20, offset: 40)

        // Then
        #expect(url == URL(string: "https://api.jolpi.ca/ergast/f1/2023/constructorStandings.json?limit=20&offset=40")!)
    }
}
