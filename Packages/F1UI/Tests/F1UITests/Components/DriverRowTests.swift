import Testing
@testable import F1UI

@MainActor
@Suite
struct DriverRowTests {
    @Test("Driver row view data preserves the identity and wikipedia indicator used for rendering")
    func viewDataPreservesRenderingFields() {
        // Given
        let viewData = F1UI.Driver.Row.ViewData(
            id: "max_verstappen",
            name: "Max Verstappen",
            nationality: "Dutch",
            showsWikipediaIndicator: true
        )

        // When
        let _ = F1UI.Driver.Row(viewData)

        // Then
        #expect(viewData.id == "max_verstappen")
        #expect(viewData.name == "Max Verstappen")
        #expect(viewData.nationality == "Dutch")
        #expect(viewData.showsWikipediaIndicator)
    }
}
