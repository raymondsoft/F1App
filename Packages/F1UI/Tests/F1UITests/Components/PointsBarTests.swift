import Testing
@testable import F1UI

@MainActor
@Suite
struct PointsBarTests {
    @Test("Points bar clamps progress between zero and one")
    func clampedProgressBetweenZeroAndOne() {
        // Given
        let belowRange = (value: -10.0, maxValue: 100.0)
        let inRange = (value: 30.0, maxValue: 100.0)
        let aboveRange = (value: 140.0, maxValue: 100.0)

        // When
        let below = F1UI.PointsBar.clampedProgress(value: belowRange.value, maxValue: belowRange.maxValue)
        let middle = F1UI.PointsBar.clampedProgress(value: inRange.value, maxValue: inRange.maxValue)
        let above = F1UI.PointsBar.clampedProgress(value: aboveRange.value, maxValue: aboveRange.maxValue)

        // Then
        #expect(below == 0)
        #expect(middle == 0.3)
        #expect(above == 1)
    }

    @Test("Points bar returns zero progress when max value is non-positive")
    func clampedProgressWithNonPositiveMax() {
        // Given
        let value = 42.0

        // When
        let zeroMax = F1UI.PointsBar.clampedProgress(value: value, maxValue: 0)
        let negativeMax = F1UI.PointsBar.clampedProgress(value: value, maxValue: -1)

        // Then
        #expect(zeroMax == 0)
        #expect(negativeMax == 0)
    }
}
