import Testing
@testable import F1UI

@MainActor
@Suite
struct StandingRowTests {
    @Test("Standing row view data preserves the rendered ranking summary")
    func viewDataPreservesRenderingFields() {
        // Given
        let viewData = F1UI.Standing.Row.ViewData(
            id: "2024-max_verstappen",
            positionText: "1",
            title: "Max Verstappen",
            subtitle: "Red Bull Racing",
            pointsText: "575 pts",
            winsText: "9 wins",
            position: 1,
            pointsValue: 575,
            maxPointsValue: 700,
            winsCount: 9
        )

        // When
        let _ = F1UI.Standing.Row(viewData)

        // Then
        #expect(viewData.id == "2024-max_verstappen")
        #expect(viewData.positionText == "1")
        #expect(viewData.title == "Max Verstappen")
        #expect(viewData.subtitle == "Red Bull Racing")
        #expect(viewData.pointsText == "575 pts")
        #expect(viewData.winsText == "9 wins")
        #expect(viewData.position == 1)
        #expect(viewData.pointsValue == 575)
        #expect(viewData.maxPointsValue == 700)
        #expect(viewData.winsCount == 9)
    }
}
