import Testing
@testable import F1Domain

@Suite
struct DriverStandingTests {
    @Test("Driver standings with the same values are equal and hash the same")
    func driverStandingsWithSameValuesAreEqual() {
        // Given
        let firstStanding = DriverStanding(
            seasonId: .init(rawValue: "2024"),
            position: 1,
            points: 575,
            wins: 9,
            driver: .fixture(id: .init(rawValue: "max_verstappen")),
            constructors: [
                .fixture(id: .init(rawValue: "red_bull"))
            ]
        )
        let secondStanding = DriverStanding(
            seasonId: .init(rawValue: "2024"),
            position: 1,
            points: 575,
            wins: 9,
            driver: .fixture(id: .init(rawValue: "max_verstappen")),
            constructors: [
                .fixture(id: .init(rawValue: "red_bull"))
            ]
        )

        // When
        let standings = Set([firstStanding, secondStanding])

        // Then
        #expect(firstStanding == secondStanding)
        #expect(standings.count == 1)
    }

    @Test("Driver standing supports a missing position and multiple constructors")
    func driverStandingSupportsMissingPositionAndMultipleConstructors() {
        // Given
        let standing = DriverStanding(
            seasonId: .init(rawValue: "2024"),
            position: nil,
            points: 8,
            wins: 0,
            driver: .fixture(id: .init(rawValue: "oliver_bearman")),
            constructors: [
                .fixture(id: .init(rawValue: "ferrari")),
                .fixture(id: .init(rawValue: "haas"))
            ]
        )

        // When
        let values = (standing.position, standing.constructors.map(\.id.rawValue))

        // Then
        #expect(values.0 == nil)
        #expect(values.1 == ["ferrari", "haas"])
    }
}
