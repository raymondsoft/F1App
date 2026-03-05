import Testing
@testable import F1UI

@MainActor
@Suite
struct SeasonProgressBarTests {
    @Test("Season progress clamps completed races between zero and total")
    func clampedProgressBetweenZeroAndOne() {
        // Given
        let belowRange = (completed: -1, total: 24)
        let inRange = (completed: 10, total: 24)
        let aboveRange = (completed: 40, total: 24)

        // When
        let below = F1UI.SeasonProgressBar.clampedProgress(completed: belowRange.completed, total: belowRange.total)
        let middle = F1UI.SeasonProgressBar.clampedProgress(completed: inRange.completed, total: inRange.total)
        let above = F1UI.SeasonProgressBar.clampedProgress(completed: aboveRange.completed, total: aboveRange.total)

        // Then
        #expect(below == 0)
        #expect(middle == Double(10) / Double(24))
        #expect(above == 1)
    }

    @Test("Season progress is zero when total races is non-positive")
    func clampedProgressWithNonPositiveTotal() {
        // Given
        let completed = 10

        // When
        let zeroTotal = F1UI.SeasonProgressBar.clampedProgress(completed: completed, total: 0)
        let negativeTotal = F1UI.SeasonProgressBar.clampedProgress(completed: completed, total: -2)

        // Then
        #expect(zeroTotal == 0)
        #expect(negativeTotal == 0)
    }
}
