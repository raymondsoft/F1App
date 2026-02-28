import Foundation
import Testing
@testable import F1Domain

@Suite
struct CircuitTests {
    @Test("Circuits with the same values are equal and hash the same")
    func circuitsWithSameValuesAreEqual() {
        // Given
        let firstCircuit = Circuit.fixture(id: .init(rawValue: "bahrain"))
        let secondCircuit = Circuit.fixture(id: .init(rawValue: "bahrain"))

        // When
        let circuits = Set([firstCircuit, secondCircuit])

        // Then
        #expect(firstCircuit == secondCircuit)
        #expect(circuits.count == 1)
    }

    @Test("Circuit supports a missing wikipedia URL")
    func circuitSupportsMissingWikipediaURL() {
        // Given
        let circuit = Circuit.fixture(
            id: .init(rawValue: "jeddah"),
            name: "Jeddah Corniche Circuit",
            wikipediaURL: nil,
            location: .fixture(
                latitude: 21.6319,
                longitude: 39.1044,
                locality: "Jeddah",
                country: "Saudi Arabia"
            )
        )

        // When
        let wikipediaURL = circuit.wikipediaURL

        // Then
        #expect(wikipediaURL == nil)
    }
}
