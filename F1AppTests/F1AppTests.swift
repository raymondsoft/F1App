import Testing
@testable import F1App

@MainActor
struct F1AppTests {

    @Test("App entry scene builds from the composition root")
    func appEntrySceneBuildsFromCompositionRoot() {
        // Given
        let sut = F1AppApp()

        // When
        let bodyTypeDescription = String(describing: type(of: sut.body))

        // Then
        #expect(bodyTypeDescription.contains("WindowGroup"))
    }

    @Test("Content view resolves to the seasons entry screen from the app container")
    func contentViewResolvesToSeasonsEntryScreen() {
        // Given
        let container = AppCompositionRoot()
        let sut = ContentView(container: container)

        // When
        let body = sut.body
        let bodyTypeDescription = String(describing: type(of: body))

        // Then
        #expect(bodyTypeDescription.contains("SeasonsScreen"))
    }
}
