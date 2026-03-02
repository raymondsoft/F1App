import Foundation
import Testing
@testable import F1Domain

@Suite
struct RaceResultTests {
    @Test("Race results with the same values are equal and hash the same")
    func raceResultsWithSameValuesAreEqual() {
        // Given
        let firstResult = RaceResult(
            seasonId: .init(rawValue: "2024"),
            round: .init(rawValue: "1"),
            raceName: "Bahrain Grand Prix",
            date: Date(timeIntervalSince1970: 1_709_251_200),
            time: .init(hour: 15, minute: 0, second: 0),
            driver: .fixture(id: .init(rawValue: "max_verstappen")),
            constructor: .fixture(id: .init(rawValue: "red_bull")),
            grid: 1,
            position: 1,
            positionText: "1",
            points: 26,
            laps: 57,
            status: "Finished",
            timeOrRetired: "1:31:44.742"
        )
        let secondResult = RaceResult(
            seasonId: .init(rawValue: "2024"),
            round: .init(rawValue: "1"),
            raceName: "Bahrain Grand Prix",
            date: Date(timeIntervalSince1970: 1_709_251_200),
            time: .init(hour: 15, minute: 0, second: 0),
            driver: .fixture(id: .init(rawValue: "max_verstappen")),
            constructor: .fixture(id: .init(rawValue: "red_bull")),
            grid: 1,
            position: 1,
            positionText: "1",
            points: 26,
            laps: 57,
            status: "Finished",
            timeOrRetired: "1:31:44.742"
        )

        // When
        let results = Set([firstResult, secondResult])

        // Then
        #expect(firstResult == secondResult)
        #expect(results.count == 1)
    }
}
