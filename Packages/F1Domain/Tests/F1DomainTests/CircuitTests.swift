import Foundation
import Testing
@testable import F1Domain

@Suite
struct CircuitTests {
    @Test("Circuits with the same values are equal and hash the same")
    func circuitsWithSameValuesAreEqual() {
        // Given
        let location = Location(
            latitude: 26.0325,
            longitude: 50.5106,
            locality: "Sakhir",
            country: "Bahrain"
        )
        let wikipediaURL = URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit")
        let firstCircuit = Circuit(
            id: .init(rawValue: "bahrain"),
            name: "Bahrain International Circuit",
            wikipediaURL: wikipediaURL,
            location: location
        )
        let secondCircuit = Circuit(
            id: .init(rawValue: "bahrain"),
            name: "Bahrain International Circuit",
            wikipediaURL: wikipediaURL,
            location: location
        )

        // When
        let circuits = Set([firstCircuit, secondCircuit])

        // Then
        #expect(firstCircuit == secondCircuit)
        #expect(circuits.count == 1)
    }

    @Test("Circuit supports a missing wikipedia URL")
    func circuitSupportsMissingWikipediaURL() {
        // Given
        let circuit = Circuit(
            id: .init(rawValue: "jeddah"),
            name: "Jeddah Corniche Circuit",
            wikipediaURL: nil,
            location: Location(
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
