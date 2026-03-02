import Foundation
import Testing
@testable import F1Domain

@Suite
struct ConstructorTests {
    @Test("Constructors with the same values are equal and hash the same")
    func constructorsWithSameValuesAreEqual() {
        // Given
        let firstConstructor = Constructor.fixture(id: .init(rawValue: "mclaren"))
        let secondConstructor = Constructor.fixture(id: .init(rawValue: "mclaren"))

        // When
        let constructors = Set([firstConstructor, secondConstructor])

        // Then
        #expect(firstConstructor == secondConstructor)
        #expect(constructors.count == 1)
    }

    @Test("Constructor identifier preserves its raw value")
    func constructorIdentifierPreservesRawValue() {
        // Given
        let constructorID = Constructor.ID(rawValue: "ferrari")

        // When
        let rawValue = constructorID.rawValue

        // Then
        #expect(rawValue == "ferrari")
    }

    @Test("Constructor supports a missing wikipedia URL")
    func constructorSupportsMissingWikipediaURL() {
        // Given
        let constructor = Constructor.fixture(
            id: .init(rawValue: "lotus"),
            wikipediaURL: nil
        )

        // When
        let wikipediaURL = constructor.wikipediaURL

        // Then
        #expect(wikipediaURL == nil)
    }
}
