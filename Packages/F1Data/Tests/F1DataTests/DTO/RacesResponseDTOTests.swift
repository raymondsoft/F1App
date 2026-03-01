import Foundation
import Testing
@testable import F1Data

@Suite
struct RacesResponseDTOTests {
    let decoder: JSONDecoder

    init() {
        decoder = JSONDecoder()
    }

    @Test("RacesResponseDTO should decode races fixture")
    func testDecodingSucceeds() throws {
        // Given
        let data = try loadJSONFixture(named: "races_2023")

        // When
        let response = try decoder.decode(RacesResponseDTO.self, from: data)

        // Then
        #expect(!response.mrData.raceTable.races.isEmpty)
    }

    @Test("Decoded race table season and count match fixture")
    func testRaceTableSeasonAndCount() throws {
        // Given
        let expectedSeason = "2023"
        let expectedCount = 2
        let data = try loadJSONFixture(named: "races_2023")

        // When
        let response = try decoder.decode(RacesResponseDTO.self, from: data)

        // Then
        #expect(response.mrData.raceTable.season == expectedSeason)
        #expect(response.mrData.raceTable.races.count == expectedCount)
    }

    @Test("Decoded first race fields match fixture values")
    func testFirstRaceFields() throws {
        // Given
        let expectedRound = "1"
        let expectedRaceName = "Bahrain Grand Prix"
        let expectedCircuitId = "bahrain"
        let expectedLocality = "Sakhir"
        let expectedCountry = "Bahrain"
        let data = try loadJSONFixture(named: "races_2023")

        // When
        let response = try decoder.decode(RacesResponseDTO.self, from: data)
        let firstRace = response.mrData.raceTable.races[0]

        // Then
        #expect(firstRace.round == expectedRound)
        #expect(firstRace.raceName == expectedRaceName)
        #expect(firstRace.circuit.circuitId == expectedCircuitId)
        #expect(firstRace.circuit.location.locality == expectedLocality)
        #expect(firstRace.circuit.location.country == expectedCountry)
    }

    @Test("Decoded races pagination fields match fixture")
    func testPaginationFields() throws {
        // Given
        let data = try loadJSONFixture(named: "races_2023")

        // When
        let response = try decoder.decode(RacesResponseDTO.self, from: data)

        // Then
        #expect(response.mrData.total == "22")
        #expect(response.mrData.limit == "30")
        #expect(response.mrData.offset == "0")
    }
}
