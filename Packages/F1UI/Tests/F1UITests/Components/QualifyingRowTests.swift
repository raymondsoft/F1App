import Testing
@testable import F1UI

@MainActor
@Suite
struct QualifyingRowTests {
    @Test("Qualifying row view data preserves the rendered lap times")
    func viewDataPreservesRenderingFields() {
        // Given
        let viewData = F1UI.Qualifying.Row.ViewData(
            id: "2024-1-max_verstappen",
            positionText: "1",
            position: 1,
            driverName: "Max Verstappen",
            constructorName: "Red Bull Racing",
            q1Text: "1:29.421",
            q2Text: "1:29.374",
            q3Text: "1:29.179",
            teamStyleToken: .redBull,
            teamShortCode: "RBR"
        )

        // When
        let _ = F1UI.Qualifying.Row(viewData)

        // Then
        #expect(viewData.id == "2024-1-max_verstappen")
        #expect(viewData.positionText == "1")
        #expect(viewData.driverName == "Max Verstappen")
        #expect(viewData.constructorName == "Red Bull Racing")
        #expect(viewData.q1Text == "1:29.421")
        #expect(viewData.q2Text == "1:29.374")
        #expect(viewData.q3Text == "1:29.179")
        #expect(viewData.position == 1)
        #expect(viewData.teamStyleToken == .redBull)
        #expect(viewData.teamShortCode == "RBR")
    }
}
