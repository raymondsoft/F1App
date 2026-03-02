import Testing
@testable import F1Domain

@Suite
struct QualifyingLapTimeTests {
    @Test("Qualifying lap time preserves its raw value")
    func qualifyingLapTimePreservesRawValue() {
        // Given
        let lapTime = QualifyingLapTime(rawValue: "1:29.407")

        // When
        let rawValue = lapTime.rawValue

        // Then
        #expect(rawValue == "1:29.407")
    }
}
