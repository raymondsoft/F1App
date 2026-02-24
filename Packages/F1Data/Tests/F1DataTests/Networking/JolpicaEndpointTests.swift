import Foundation
import Testing
@testable import F1Data

@Suite
struct JolpicaEndpointTests {
    @Test("Seasons endpoint should use default Jolpica base URL")
    func testSeasonsURLWithDefaultBase() {
        // Given
        let sut = JolpicaEndpoint()
        let expectedURL = URL(string: "https://api.jolpi.ca/api/f1/seasons.json")!

        // When
        let url = sut.seasonsURL()

        // Then
        #expect(url == expectedURL)
    }

    @Test("Races endpoint should include the provided season segment")
    func testRacesURLForSeason() {
        // Given
        let sut = JolpicaEndpoint()
        let expectedURL = URL(string: "https://api.jolpi.ca/api/f1/2023/races.json")!

        // When
        let url = sut.racesURL(season: "2023")

        // Then
        #expect(url == expectedURL)
    }

    @Test("Endpoints should use a custom base URL when provided")
    func testEndpointsWithCustomBaseURL() {
        // Given
        let sut = JolpicaEndpoint(baseURL: URL(string: "https://example.com")!)
        let expectedSeasonsURL = URL(string: "https://example.com/api/f1/seasons.json")!
        let expectedRacesURL = URL(string: "https://example.com/api/f1/2024/races.json")!

        // When
        let seasonsURL = sut.seasonsURL()
        let racesURL = sut.racesURL(season: "2024")

        // Then
        #expect(seasonsURL == expectedSeasonsURL)
        #expect(racesURL == expectedRacesURL)
    }

    @Test("Endpoints should preserve existing path segments in custom base URL")
    func testEndpointsWithCustomBaseURLContainingPath() {
        // Given
        let sut = JolpicaEndpoint(baseURL: URL(string: "https://example.com/proxy/v1")!)
        let expectedSeasonsURL = URL(string: "https://example.com/proxy/v1/api/f1/seasons.json")!
        let expectedRacesURL = URL(string: "https://example.com/proxy/v1/api/f1/2024/races.json")!

        // When
        let seasonsURL = sut.seasonsURL()
        let racesURL = sut.racesURL(season: "2024")

        // Then
        #expect(seasonsURL == expectedSeasonsURL)
        #expect(racesURL == expectedRacesURL)
    }

    @Test("Races endpoint should accept non-numeric season input as raw path segment")
    func testRacesURLWithNonNumericSeason() {
        // Given
        let sut = JolpicaEndpoint()
        let expectedURL = URL(string: "https://api.jolpi.ca/api/f1/current/races.json")!

        // When
        let url = sut.racesURL(season: "current")

        // Then
        #expect(url == expectedURL)
    }
}
