import Foundation
import Testing
@testable import F1Domain

@Suite
struct RaceTests {
    @Test("Races with the same values are equal and hash the same")
    func racesWithSameValuesAreEqual() {
        // Given
        let raceDate = Date(timeIntervalSince1970: 1_710_028_800)
        let location = Location(
            latitude: 26.0325,
            longitude: 50.5106,
            locality: "Sakhir",
            country: "Bahrain"
        )
        let circuit = Circuit(
            id: .init(rawValue: "bahrain"),
            name: "Bahrain International Circuit",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit"),
            location: location
        )
        let firstRace = Race(
            seasonId: .init(rawValue: "2024"),
            round: "1",
            name: "Bahrain Grand Prix",
            date: raceDate,
            time: "15:00:00Z",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/2024_Bahrain_Grand_Prix"),
            circuit: circuit
        )
        let secondRace = Race(
            seasonId: .init(rawValue: "2024"),
            round: "1",
            name: "Bahrain Grand Prix",
            date: raceDate,
            time: "15:00:00Z",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/2024_Bahrain_Grand_Prix"),
            circuit: circuit
        )

        // When
        let races = Set([firstRace, secondRace])

        // Then
        #expect(firstRace == secondRace)
        #expect(races.count == 1)
    }

    @Test("Race supports a missing start time")
    func raceSupportsMissingStartTime() {
        // Given
        let race = Race(
            seasonId: .init(rawValue: "2024"),
            round: "2",
            name: "Saudi Arabian Grand Prix",
            date: Date(timeIntervalSince1970: 1_710_633_600),
            time: nil,
            wikipediaURL: nil,
            circuit: Circuit(
                id: .init(rawValue: "jeddah"),
                name: "Jeddah Corniche Circuit",
                wikipediaURL: nil,
                location: Location(
                    latitude: 21.6319,
                    longitude: 39.1044,
                    locality: "Jeddah",
                    country: "Saudi Arabia"
                )
            )
        )

        // When
        let time = race.time

        // Then
        #expect(time == nil)
    }
}
