import Foundation
import Testing
@testable import F1Domain

@Suite
struct DriverTests {
    @Test("Drivers with the same values are equal and hash the same")
    func driversWithSameValuesAreEqual() {
        // Given
        let firstDriver = Driver.fixture(id: .init(rawValue: "max_verstappen"))
        let secondDriver = Driver.fixture(id: .init(rawValue: "max_verstappen"))

        // When
        let drivers = Set([firstDriver, secondDriver])

        // Then
        #expect(firstDriver == secondDriver)
        #expect(drivers.count == 1)
    }

    @Test("Driver identifier preserves its raw value")
    func driverIdentifierPreservesRawValue() {
        // Given
        let driverID = Driver.ID(rawValue: "lewis_hamilton")

        // When
        let rawValue = driverID.rawValue

        // Then
        #expect(rawValue == "lewis_hamilton")
    }

    @Test("Driver supports a missing wikipedia URL")
    func driverSupportsMissingWikipediaURL() {
        // Given
        let driver = Driver.fixture(
            id: .init(rawValue: "ayrton_senna"),
            wikipediaURL: nil
        )

        // When
        let wikipediaURL = driver.wikipediaURL

        // Then
        #expect(wikipediaURL == nil)
    }
}
