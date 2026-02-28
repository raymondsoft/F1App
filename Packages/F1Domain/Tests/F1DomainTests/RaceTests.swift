import Foundation
import Testing
@testable import F1Domain

@Suite
struct RaceTests {
    @Test("Races with the same values are equal and hash the same")
    func racesWithSameValuesAreEqual() {
        // Given
        let firstRace = Race.fixture(
            seasonId: .init(rawValue: "2024"),
            round: .init(rawValue: "1"),
            circuit: .fixture(id: .init(rawValue: "bahrain"))
        )
        let secondRace = Race.fixture(
            seasonId: .init(rawValue: "2024"),
            round: .init(rawValue: "1"),
            circuit: .fixture(id: .init(rawValue: "bahrain"))
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
        let race = Race.fixture(
            seasonId: .init(rawValue: "2024"),
            round: .init(rawValue: "2"),
            name: "Saudi Arabian Grand Prix",
            date: Date(timeIntervalSince1970: 1_710_633_600),
            time: nil,
            wikipediaURL: nil,
            circuit: .fixture(
                id: .init(rawValue: "jeddah"),
                name: "Jeddah Corniche Circuit",
                wikipediaURL: nil,
                location: .fixture(
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

    @Test("Race round preserves its raw value")
    func raceRoundPreservesRawValue() {
        // Given
        let round = Race.Round(rawValue: "12")

        // When
        let rawValue = round.rawValue

        // Then
        #expect(rawValue == "12")
    }

    @Test("Race time stores numeric components instead of transport strings")
    func raceTimeStoresNumericComponents() {
        // Given
        let time = Race.Time(hour: 22, minute: 30, second: 45, utcOffsetSeconds: 0)

        // When
        let components = (time.hour, time.minute, time.second, time.utcOffsetSeconds)

        // Then
        #expect(components.0 == 22)
        #expect(components.1 == 30)
        #expect(components.2 == 45)
        #expect(components.3 == 0)
    }
}
