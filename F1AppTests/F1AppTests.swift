import Testing
@testable import F1App

@MainActor
struct F1AppTests {

    @Test("App composition root builds the use cases required by the root flow")
    func appCompositionRootBuildsRequiredUseCases() {
        // Given
        let sut = AppCompositionRoot()

        // When
        let propertyLabels = Set(Mirror(reflecting: sut).children.compactMap(\.label))

        // Then
        #expect(propertyLabels == [
            "getSeasonsPageUseCase",
            "getDriversPageUseCase",
            "getConstructorsPageUseCase",
            "getRacesForSeasonUseCase",
            "getRaceResultsPageUseCase",
            "getQualifyingResultsPageUseCase",
            "getDriverStandingsPageUseCase",
            "getConstructorStandingsPageUseCase"
        ])
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
