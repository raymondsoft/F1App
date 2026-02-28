import Foundation
import Testing
import F1Domain
@testable import F1Data

@Suite
struct JolpicaF1RepositoryTests {
    @Test("JolpicaF1Repository should return domain seasons from seasons fixture")
    func testSeasonsReturnsDomainSeasons() async throws {
        // Given
        let seasonsURL = URL(string: "https://api.jolpi.ca/api/f1/seasons.json")!
        let seasonsData = try loadJSONFixture(named: "seasons")
        let httpClientStub = HTTPClientStub(
            responses: [
                seasonsURL: .success(seasonsData)
            ]
        )
        let sut = JolpicaF1Repository(httpClient: httpClientStub)

        // When
        let seasons = try await sut.seasons()

        // Then
        #expect(seasons.count == 3)
        #expect(seasons[0].id == Season.ID(rawValue: "2023"))
        #expect(seasons[0].wikipediaURL == URL(string: "https://en.wikipedia.org/wiki/2023_Formula_One_World_Championship"))
    }

    @Test("JolpicaF1Repository should return domain races from races fixture")
    func testRacesReturnsDomainRaces() async throws {
        // Given
        let racesURL = URL(string: "https://api.jolpi.ca/api/f1/2023/races.json")!
        let racesData = try loadJSONFixture(named: "races_2023")
        let httpClientStub = HTTPClientStub(
            responses: [
                racesURL: .success(racesData)
            ]
        )
        let sut = JolpicaF1Repository(httpClient: httpClientStub)

        // When
        let races = try await sut.races(seasonId: Season.ID(rawValue: "2023"))

        // Then
        #expect(races.count == 2)
        #expect(races[0].round == Race.Round(rawValue: "1"))
        #expect(races[0].name == "Bahrain Grand Prix")
        #expect(races[0].circuit.location.latitude == 26.0325)
    }

    @Test("JolpicaF1Repository should propagate HTTPClient errors")
    func testPropagatesHTTPClientErrors() async {
        // Given
        let seasonsURL = URL(string: "https://api.jolpi.ca/api/f1/seasons.json")!
        let expectedError = DataError.network(underlying: "request failed")
        let httpClientStub = HTTPClientStub(
            responses: [
                seasonsURL: .failure(expectedError)
            ]
        )
        let sut = JolpicaF1Repository(httpClient: httpClientStub)

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

    @Test("JolpicaF1Repository should throw mapping error for invalid race coordinates")
    func testThrowsMappingError() async {
        // Given
        let racesURL = URL(string: "https://api.jolpi.ca/api/f1/2023/races.json")!
        let invalidRacesData = Data(
            """
            {
              "MRData": {
                "RaceTable": {
                  "season": "2023",
                  "Races": [
                    {
                      "season": "2023",
                      "round": "1",
                      "url": "https://en.wikipedia.org/wiki/2023_Bahrain_Grand_Prix",
                      "raceName": "Bahrain Grand Prix",
                      "Circuit": {
                        "circuitId": "bahrain",
                        "url": "https://en.wikipedia.org/wiki/Bahrain_International_Circuit",
                        "circuitName": "Bahrain International Circuit",
                        "Location": {
                          "lat": "invalid",
                          "long": "50.5106",
                          "locality": "Sakhir",
                          "country": "Bahrain"
                        }
                      },
                      "date": "2023-03-05",
                      "time": "15:00:00Z"
                    }
                  ]
                }
              }
            }
            """.utf8
        )
        let httpClientStub = HTTPClientStub(
            responses: [
                racesURL: .success(invalidRacesData)
            ]
        )
        let sut = JolpicaF1Repository(httpClient: httpClientStub)

        // When
        do {
            _ = try await sut.races(seasonId: Season.ID(rawValue: "2023"))
            Issue.record("Expected DataError.mapping to be thrown")
        } catch let error as DataError {
            // Then
            #expect(error == .mapping(underlying: "Invalid latitude: invalid"))
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }
}
