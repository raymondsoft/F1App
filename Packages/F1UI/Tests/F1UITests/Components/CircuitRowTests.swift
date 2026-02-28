import Testing
@testable import F1UI

@MainActor
@Suite
struct CircuitRowTests {
    @Test("Circuit row view data preserves the location and wikipedia indicator used for rendering")
    func viewDataPreservesRenderingFields() {
        // Given
        let viewData = F1UI.Circuit.Row.ViewData(
            id: "silverstone",
            name: "Silverstone Circuit",
            locality: "Silverstone",
            country: "United Kingdom",
            showsWikipediaIndicator: true
        )

        // When
        let _ = F1UI.Circuit.Row(viewData)

        // Then
        #expect(viewData.id == "silverstone")
        #expect(viewData.name == "Silverstone Circuit")
        #expect(viewData.locality == "Silverstone")
        #expect(viewData.country == "United Kingdom")
        #expect(viewData.showsWikipediaIndicator)
    }
}
