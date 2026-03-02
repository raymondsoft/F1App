import Testing
@testable import F1UI

@MainActor
@Suite
struct ConstructorRowTests {
    @Test("Constructor row view data preserves the identity and wikipedia indicator used for rendering")
    func viewDataPreservesRenderingFields() {
        // Given
        let viewData = F1UI.Constructor.Row.ViewData(
            id: "mclaren",
            name: "McLaren",
            nationality: "British",
            showsWikipediaIndicator: true
        )

        // When
        let _ = F1UI.Constructor.Row(viewData)

        // Then
        #expect(viewData.id == "mclaren")
        #expect(viewData.name == "McLaren")
        #expect(viewData.nationality == "British")
        #expect(viewData.showsWikipediaIndicator)
    }
}
