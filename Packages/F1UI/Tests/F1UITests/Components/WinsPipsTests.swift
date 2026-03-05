import Testing
@testable import F1UI

@MainActor
@Suite
struct WinsPipsTests {
    @Test("Wins pips caps visible count using max visible slots")
    func visiblePipCountCapsAtMaxVisible() {
        // Given
        let wins = 15
        let maxVisible = 10

        // When
        let visibleCount = F1UI.WinsPips.visiblePipCount(wins: wins, maxVisible: maxVisible)

        // Then
        #expect(visibleCount == 10)
    }

    @Test("Wins pips computes overflow count when wins exceed visible slots")
    func overflowCountForExtraWins() {
        // Given
        let wins = 15
        let maxVisible = 10

        // When
        let overflow = F1UI.WinsPips.overflowCount(wins: wins, maxVisible: maxVisible)

        // Then
        #expect(overflow == 5)
    }

    @Test("Wins pips returns zero counts for negative wins")
    func nonNegativeCounts() {
        // Given
        let wins = -3
        let maxVisible = 10

        // When
        let visibleCount = F1UI.WinsPips.visiblePipCount(wins: wins, maxVisible: maxVisible)
        let overflow = F1UI.WinsPips.overflowCount(wins: wins, maxVisible: maxVisible)

        // Then
        #expect(visibleCount == 0)
        #expect(overflow == 0)
    }
}
