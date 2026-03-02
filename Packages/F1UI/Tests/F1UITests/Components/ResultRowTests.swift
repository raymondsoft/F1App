import Testing
@testable import F1UI

@MainActor
@Suite
struct ResultRowTests {
    @Test("Result row view data preserves the rendered finishing summary")
    func viewDataPreservesRenderingFields() {
        // Given
        let viewData = F1UI.Result.Row.ViewData(
            id: "2024-1-max_verstappen",
            positionText: "1",
            driverName: "Max Verstappen",
            constructorName: "Red Bull Racing",
            pointsText: "25 pts",
            resultText: "1:31:44.742"
        )

        // When
        let _ = F1UI.Result.Row(viewData)

        // Then
        #expect(viewData.id == "2024-1-max_verstappen")
        #expect(viewData.positionText == "1")
        #expect(viewData.driverName == "Max Verstappen")
        #expect(viewData.constructorName == "Red Bull Racing")
        #expect(viewData.pointsText == "25 pts")
        #expect(viewData.resultText == "1:31:44.742")
    }
}
