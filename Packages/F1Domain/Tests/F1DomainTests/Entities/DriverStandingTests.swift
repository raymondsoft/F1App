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
}
