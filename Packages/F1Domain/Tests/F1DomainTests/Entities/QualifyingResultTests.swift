import Testing
@testable import F1Domain

@Suite
struct QualifyingResultTests {
    @Test("Qualifying results with the same values are equal and hash the same")
    func qualifyingResultsWithSameValuesAreEqual() {
        // Given
        let firstResult = QualifyingResult(
            seasonId: .init(rawValue: "2024"),
            round: .init(rawValue: "1"),
            driver: .fixture(id: .init(rawValue: "charles_leclerc")),
            constructor: .fixture(id: .init(rawValue: "ferrari")),
            position: 2,
            q1: "1:29.165",
            q2: "1:29.131",
            q3: "1:29.407"
        )
        let secondResult = QualifyingResult(
            seasonId: .init(rawValue: "2024"),
            round: .init(rawValue: "1"),
            driver: .fixture(id: .init(rawValue: "charles_leclerc")),
            constructor: .fixture(id: .init(rawValue: "ferrari")),
            position: 2,
            q1: "1:29.165",
            q2: "1:29.131",
            q3: "1:29.407"
        )

        // When
        let results = Set([firstResult, secondResult])

        // Then
        #expect(firstResult == secondResult)
        #expect(results.count == 1)
    }
}
