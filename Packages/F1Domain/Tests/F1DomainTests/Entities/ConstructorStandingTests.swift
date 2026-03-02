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

    @Test("Constructor standing supports a missing position")
    func constructorStandingSupportsMissingPosition() {
        // Given
        let standing = ConstructorStanding(
            seasonId: .init(rawValue: "2024"),
            position: nil,
            points: 12,
            wins: 0,
            constructor: .fixture(id: .init(rawValue: "williams"))
        )

        // When
        let position = standing.position

        // Then
        #expect(position == nil)
    }
}
