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

    @Test("Qualifying result supports missing later session times and position")
    func qualifyingResultSupportsMissingLaterSessionTimesAndPosition() {
        // Given
        let result = QualifyingResult(
            seasonId: .init(rawValue: "2024"),
            round: .init(rawValue: "3"),
            driver: .fixture(id: .init(rawValue: "guanyu_zhou")),
            constructor: .fixture(id: .init(rawValue: "sauber")),
            position: nil,
            q1: "1:31.234",
            q2: nil,
            q3: nil
        )

        // When
        let values = (result.position, result.q1, result.q2, result.q3)

        // Then
        #expect(values.0 == nil)
        #expect(values.1 == "1:31.234")
        #expect(values.2 == nil)
        #expect(values.3 == nil)
    }
}
