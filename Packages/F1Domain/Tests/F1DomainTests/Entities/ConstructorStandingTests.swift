import Testing
@testable import F1Domain

@Suite
struct ConstructorStandingTests {
    @Test("Constructor standings with the same values are equal and hash the same")
    func constructorStandingsWithSameValuesAreEqual() {
        // Given
        let firstStanding = ConstructorStanding(
            seasonId: .init(rawValue: "2024"),
            position: 1,
            points: 860,
            wins: 14,
            constructor: .fixture(id: .init(rawValue: "mclaren"))
        )
        let secondStanding = ConstructorStanding(
            seasonId: .init(rawValue: "2024"),
            position: 1,
            points: 860,
            wins: 14,
            constructor: .fixture(id: .init(rawValue: "mclaren"))
        )

        // When
        let standings = Set([firstStanding, secondStanding])

        // Then
        #expect(firstStanding == secondStanding)
        #expect(standings.count == 1)
    }
}
