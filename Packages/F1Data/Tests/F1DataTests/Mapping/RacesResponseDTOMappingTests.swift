import Foundation
import Testing
import F1Domain
@testable import F1Data

@Suite
struct RacesResponseDTOMappingTests {
    @Test("RacesResponseDTO should map races fixture to domain races")
    func testMappingRacesFixture() throws {
        // Given
        let data = try loadJSONFixture(named: "races_2023")
        let decoder = JSONDecoder()
        let response = try decoder.decode(RacesResponseDTO.self, from: data)
        let expectedDate = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: TimeZone(secondsFromGMT: 0),
            year: 2023,
            month: 3,
            day: 5
        ).date

        // When
        let races = try response.toDomain()

        // Then
        #expect(races.count == 2)
        #expect(races[0].seasonId == Season.ID(rawValue: "2023"))
        #expect(races[0].round == Race.Round(rawValue: "1"))
        #expect(races[0].name == "Bahrain Grand Prix")
        #expect(races[0].wikipediaURL == URL(string: "https://en.wikipedia.org/wiki/2023_Bahrain_Grand_Prix"))
        #expect(races[0].circuit.id == Circuit.ID(rawValue: "bahrain"))
        #expect(races[0].circuit.name == "Bahrain International Circuit")
        #expect(races[0].circuit.wikipediaURL == URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit"))
        #expect(races[0].circuit.location.latitude == 26.0325)
        #expect(races[0].circuit.location.longitude == 50.5106)
        #expect(races[0].circuit.location.locality == "Sakhir")
        #expect(races[0].circuit.location.country == "Bahrain")
        #expect(races[0].date == expectedDate)
        #expect(races[0].time == Race.Time(hour: 15, minute: 0, second: 0, utcOffsetSeconds: 0))
    }

    @Test("RacesResponseDTO should parse UTC offset time into Race.Time")
    func testMappingOffsetTime() throws {
        // Given
        let response = makeRacesResponseDTO(time: "15:00:00+02:00")

        // When
        let races = try response.toDomain()

        // Then
        #expect(races[0].time == Race.Time(hour: 15, minute: 0, second: 0, utcOffsetSeconds: 7200))
    }

    @Test("RacesResponseDTO should throw mapping error for invalid date")
    func testMappingInvalidDateThrows() {
        // Given
        let response = makeRacesResponseDTO(date: "2023-02-30")

        // When
        do {
            _ = try response.toDomain()
            Issue.record("Expected DataError.mapping to be thrown")
        } catch let error as DataError {
            // Then
            #expect(error == .mapping(underlying: "Invalid date: 2023-02-30"))
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test("RacesResponseDTO should throw mapping error for invalid time")
    func testMappingInvalidTimeThrows() {
        // Given
        let response = makeRacesResponseDTO(time: "25:99:99+02:00")

        // When
        do {
            _ = try response.toDomain()
            Issue.record("Expected DataError.mapping to be thrown")
        } catch let error as DataError {
            // Then
            #expect(error == .mapping(underlying: "Invalid time: 25:99:99+02:00"))
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test("RacesResponseDTO should map invalid circuit URL strings to nil")
    func testMappingInvalidCircuitURLToNil() throws {
        // Given
        let response = makeRacesResponseDTO(circuitURL: "https://exa mple.com")

        // When
        let races = try response.toDomain()

        // Then
        #expect(races[0].circuit.wikipediaURL == nil)
    }

    private func makeRacesResponseDTO(
        date: String = "2023-03-05",
        time: String? = "15:00:00Z",
        circuitURL: String = "https://en.wikipedia.org/wiki/Bahrain_International_Circuit"
    ) -> RacesResponseDTO {
        RacesResponseDTO(
            mrData: .init(
                raceTable: .init(
                    season: "2023",
                    races: [
                        .init(
                            season: "2023",
                            round: "1",
                            url: "https://en.wikipedia.org/wiki/2023_Bahrain_Grand_Prix",
                            raceName: "Bahrain Grand Prix",
                            circuit: .init(
                                circuitId: "bahrain",
                                url: circuitURL,
                                circuitName: "Bahrain International Circuit",
                                location: .init(
                                    latitude: "26.0325",
                                    longitude: "50.5106",
                                    locality: "Sakhir",
                                    country: "Bahrain"
                                )
                            ),
                            date: date,
                            time: time
                        )
                    ]
                )
            )
        )
    }
}
