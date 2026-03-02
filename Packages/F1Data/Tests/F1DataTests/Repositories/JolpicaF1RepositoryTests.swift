import Foundation
import Testing
import F1Domain
@testable import F1Data

@Suite
struct JolpicaF1RepositoryTests {
    @Test("JolpicaF1Repository should return paged drivers and request the expected URL")
    func testDriversPage() async throws {
        // Given
        let data = try loadJSONFixture(named: "drivers_2023")
        let httpClientMock = HTTPClientMock(result: .success(data))
        let sut = JolpicaF1Repository(httpClient: httpClientMock)
        let request = try PageRequest(limit: 2, offset: 0)

        // When
        let page = try await sut.driversPage(seasonId: Season.ID(rawValue: "2023"), request: request)

        // Then
        #expect(httpClientMock.requestedURLs == [URL(string: "https://api.jolpi.ca/ergast/f1/2023/drivers.json?limit=2&offset=0")!])
        #expect(page.total == 24)
        #expect(page.limit == 2)
        #expect(page.offset == 0)
        #expect(page.hasMore == true)
        #expect(page.items[0].id == Driver.ID(rawValue: "max_verstappen"))
    }

    @Test("JolpicaF1Repository should return paged constructors and request the expected URL")
    func testConstructorsPage() async throws {
        // Given
        let data = try loadJSONFixture(named: "constructors_2023")
        let httpClientMock = HTTPClientMock(result: .success(data))
        let sut = JolpicaF1Repository(httpClient: httpClientMock)
        let request = try PageRequest(limit: 2, offset: 0)

        // When
        let page = try await sut.constructorsPage(seasonId: Season.ID(rawValue: "2023"), request: request)

        // Then
        #expect(httpClientMock.requestedURLs == [URL(string: "https://api.jolpi.ca/ergast/f1/2023/constructors.json?limit=2&offset=0")!])
        #expect(page.total == 10)
        #expect(page.hasMore == true)
        #expect(page.items[0].id == Constructor.ID(rawValue: "red_bull"))
    }

    @Test("JolpicaF1Repository should return paged race results and request the expected URL")
    func testRaceResultsPage() async throws {
        // Given
        let data = try loadJSONFixture(named: "race_results_2023_round1")
        let httpClientMock = HTTPClientMock(result: .success(data))
        let sut = JolpicaF1Repository(httpClient: httpClientMock)
        let request = try PageRequest(limit: 2, offset: 0)

        // When
        let page = try await sut.raceResultsPage(
            seasonId: Season.ID(rawValue: "2023"),
            round: Race.Round(rawValue: "1"),
            request: request
        )

        // Then
        #expect(httpClientMock.requestedURLs == [URL(string: "https://api.jolpi.ca/ergast/f1/2023/1/results.json?limit=2&offset=0")!])
        #expect(page.total == 20)
        #expect(page.hasMore == true)
        #expect(page.items.count == 2)
        #expect(page.items[0].resultTime == .time("1:33:56.736"))
    }

    @Test("JolpicaF1Repository should return paged qualifying results and request the expected URL")
    func testQualifyingResultsPage() async throws {
        // Given
        let data = try loadJSONFixture(named: "qualifying_results_2023_round1")
        let httpClientMock = HTTPClientMock(result: .success(data))
        let sut = JolpicaF1Repository(httpClient: httpClientMock)
        let request = try PageRequest(limit: 2, offset: 0)

        // When
        let page = try await sut.qualifyingResultsPage(
            seasonId: Season.ID(rawValue: "2023"),
            round: Race.Round(rawValue: "1"),
            request: request
        )

        // Then
        #expect(httpClientMock.requestedURLs == [URL(string: "https://api.jolpi.ca/ergast/f1/2023/1/qualifying.json?limit=2&offset=0")!])
        #expect(page.total == 20)
        #expect(page.hasMore == true)
        #expect(page.items[0].q3 == QualifyingLapTime(rawValue: "1:29.708"))
    }

    @Test("JolpicaF1Repository should return paged driver standings and request the expected URL")
    func testDriverStandingsPage() async throws {
        // Given
        let data = try loadJSONFixture(named: "driver_standings_2023")
        let httpClientMock = HTTPClientMock(result: .success(data))
        let sut = JolpicaF1Repository(httpClient: httpClientMock)
        let request = try PageRequest(limit: 2, offset: 0)

        // When
        let page = try await sut.driverStandingsPage(seasonId: Season.ID(rawValue: "2023"), request: request)

        // Then
        #expect(httpClientMock.requestedURLs == [URL(string: "https://api.jolpi.ca/ergast/f1/2023/driverStandings.json?limit=2&offset=0")!])
        #expect(page.total == 22)
        #expect(page.hasMore == true)
        #expect(page.items[0].wins == 19)
    }

    @Test("JolpicaF1Repository should return paged constructor standings and request the expected URL")
    func testConstructorStandingsPage() async throws {
        // Given
        let data = try loadJSONFixture(named: "constructor_standings_2023")
        let httpClientMock = HTTPClientMock(result: .success(data))
        let sut = JolpicaF1Repository(httpClient: httpClientMock)
        let request = try PageRequest(limit: 2, offset: 0)

        // When
        let page = try await sut.constructorStandingsPage(seasonId: Season.ID(rawValue: "2023"), request: request)

        // Then
        #expect(httpClientMock.requestedURLs == [URL(string: "https://api.jolpi.ca/ergast/f1/2023/constructorStandings.json?limit=2&offset=0")!])
        #expect(page.total == 10)
        #expect(page.hasMore == true)
        #expect(page.items[0].constructor.id == Constructor.ID(rawValue: "red_bull"))
    }

    @Test("JolpicaF1Repository should propagate HTTPClient errors from drivers page")
    func testDriversPagePropagatesHTTPError() async {
        // Given
        let expectedError = DataError.network(underlying: "request failed")
        let httpClientMock = HTTPClientMock(result: .failure(expectedError))
        let sut = JolpicaF1Repository(httpClient: httpClientMock)
        let request = try! PageRequest(limit: 2, offset: 0)

        // When
        do {
            _ = try await sut.driversPage(seasonId: Season.ID(rawValue: "2023"), request: request)
            Issue.record("Expected DataError.network to be thrown")
        } catch let error as DataError {
            // Then
            #expect(error == expectedError)
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test("JolpicaF1Repository should propagate decoding errors from constructors page")
    func testConstructorsPagePropagatesDecodingError() async {
        // Given
        let httpClientMock = HTTPClientMock(result: .success(Data("not-json".utf8)))
        let sut = JolpicaF1Repository(httpClient: httpClientMock)
        let request = try! PageRequest(limit: 2, offset: 0)

        // When
        do {
            _ = try await sut.constructorsPage(seasonId: Season.ID(rawValue: "2023"), request: request)
            Issue.record("Expected DecodingError to be thrown")
        } catch is DecodingError {
            // Then
            #expect(Bool(true))
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test("JolpicaF1Repository should propagate mapping errors from race results page")
    func testRaceResultsPagePropagatesMappingError() async {
        // Given
        let url = URL(string: "https://api.jolpi.ca/ergast/f1/2023/1/results.json?limit=2&offset=0")!
        let invalidData = Data(
            """
            {
              "MRData": {
                "limit": "2",
                "offset": "0",
                "total": "20",
                "RaceTable": {
                  "season": "2023",
                  "round": "1",
                  "Races": [
                    {
                      "season": "2023",
                      "round": "1",
                      "raceName": "Bahrain Grand Prix",
                      "date": "2023-03-05",
                      "time": "15:00:00Z",
                      "Results": [
                        {
                          "position": "1",
                          "positionText": "1",
                          "points": "oops",
                          "Driver": {
                            "driverId": "max_verstappen",
                            "url": "https://en.wikipedia.org/wiki/Max_Verstappen",
                            "givenName": "Max",
                            "familyName": "Verstappen",
                            "dateOfBirth": "1997-09-30",
                            "nationality": "Dutch"
                          },
                          "Constructor": {
                            "constructorId": "red_bull",
                            "url": "https://en.wikipedia.org/wiki/Red_Bull_Racing",
                            "name": "Red Bull",
                            "nationality": "Austrian"
                          },
                          "grid": "1",
                          "laps": "57",
                          "status": "Finished"
                        }
                      ]
                    }
                  ]
                }
              }
            }
            """.utf8
        )
        let httpClientStub = HTTPClientStub(responses: [url: .success(invalidData)])
        let sut = JolpicaF1Repository(httpClient: httpClientStub)
        let request = try! PageRequest(limit: 2, offset: 0)

        // When
        do {
            _ = try await sut.raceResultsPage(
                seasonId: Season.ID(rawValue: "2023"),
                round: Race.Round(rawValue: "1"),
                request: request
            )
            Issue.record("Expected DataError.mapping to be thrown")
        } catch let error as DataError {
            // Then
            #expect(error == .mapping(underlying: "Invalid points: oops"))
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test("JolpicaF1Repository should use fallback hasMore logic when total is missing")
    func testQualifyingResultsPageFallbackHasMore() async throws {
        // Given
        let url = URL(string: "https://api.jolpi.ca/ergast/f1/2023/1/qualifying.json?limit=2&offset=0")!
        let dataWithoutTotal = Data(
            """
            {
              "MRData": {
                "limit": "2",
                "offset": "0",
                "RaceTable": {
                  "season": "2023",
                  "round": "1",
                  "Races": [
                    {
                      "season": "2023",
                      "round": "1",
                      "QualifyingResults": [
                        {
                          "position": "1",
                          "Driver": {
                            "driverId": "max_verstappen",
                            "url": "https://en.wikipedia.org/wiki/Max_Verstappen",
                            "givenName": "Max",
                            "familyName": "Verstappen",
                            "dateOfBirth": "1997-09-30",
                            "nationality": "Dutch"
                          },
                          "Constructor": {
                            "constructorId": "red_bull",
                            "url": "https://en.wikipedia.org/wiki/Red_Bull_Racing",
                            "name": "Red Bull",
                            "nationality": "Austrian"
                          },
                          "Q1": "1:30.503",
                          "Q2": "1:30.503"
                        },
                        {
                          "position": "2",
                          "Driver": {
                            "driverId": "leclerc",
                            "url": "https://en.wikipedia.org/wiki/Charles_Leclerc",
                            "givenName": "Charles",
                            "familyName": "Leclerc",
                            "dateOfBirth": "1997-10-16",
                            "nationality": "Monegasque"
                          },
                          "Constructor": {
                            "constructorId": "ferrari",
                            "url": "https://en.wikipedia.org/wiki/Scuderia_Ferrari",
                            "name": "Ferrari",
                            "nationality": "Italian"
                          },
                          "Q1": "1:31.094",
                          "Q2": "1:30.282"
                        }
                      ]
                    }
                  ]
                }
              }
            }
            """.utf8
        )
        let httpClientStub = HTTPClientStub(responses: [url: .success(dataWithoutTotal)])
        let sut = JolpicaF1Repository(httpClient: httpClientStub)
        let request = try PageRequest(limit: 2, offset: 0)

        // When
        let page = try await sut.qualifyingResultsPage(
            seasonId: Season.ID(rawValue: "2023"),
            round: Race.Round(rawValue: "1"),
            request: request
        )

        // Then
        #expect(page.total == nil)
        #expect(page.limit == 2)
        #expect(page.offset == 0)
        #expect(page.hasMore == true)
    }
}
