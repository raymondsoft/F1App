import Testing
@testable import F1UI

@Suite
struct TeamStyleRegistryTests {
    @Test("Known constructor id resolves to expected team style token and short code")
    func knownConstructorIDResolvesStyle() {
        // Given
        let constructorID = "red_bull"

        // When
        let style = TeamStyleRegistry.style(for: constructorID)

        // Then
        #expect(style == TeamStyle(token: .redBull, shortCode: "RBR"))
    }

    @Test("Unknown constructor id returns no team style")
    func unknownConstructorIDReturnsNil() {
        // Given
        let constructorID = "my_custom_team"

        // When
        let style = TeamStyleRegistry.style(for: constructorID)

        // Then
        #expect(style == nil)
    }
}
