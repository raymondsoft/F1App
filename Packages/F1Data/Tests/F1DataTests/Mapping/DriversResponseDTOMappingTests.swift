import Foundation
import Testing
import F1Domain
@testable import F1Data

@Suite
struct DriversResponseDTOMappingTests {
    @Test("DriversResponseDTO should map drivers fixture to a paged domain response")
    func testDriversMapping() throws {
        // Given
        let data = try loadJSONFixture(named: "drivers_2023")
        let decoder = JSONDecoder()
        let response = try decoder.decode(DriversResponseDTO.self, from: data)
        let expectedBirthDate = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: TimeZone(secondsFromGMT: 0),
            year: 1997,
            month: 9,
            day: 30
        ).date

        // When
        let page = try response.toPage()

        // Then
        #expect(page.items.count == 2)
        #expect(page.total == 24)
        #expect(page.hasMore == true)
        #expect(page.items[0].id == Driver.ID(rawValue: "max_verstappen"))
        #expect(page.items[0].familyName == "Verstappen")
        #expect(page.items[0].dateOfBirth == expectedBirthDate)
        #expect(page.items[0].wikipediaURL == URL(string: "https://en.wikipedia.org/wiki/Max_Verstappen"))
    }

    @Test("DriversResponseDTO should throw mapping error for invalid date of birth")
    func testDriversMappingInvalidDateOfBirth() {
        // Given
        let response = DriversResponseDTO(
            mrData: .init(
                total: "24",
                limit: "2",
                offset: "0",
                driverTable: .init(
                    season: "2023",
                    drivers: [
                        .init(
                            driverId: "max_verstappen",
                            url: "https://en.wikipedia.org/wiki/Max_Verstappen",
                            givenName: "Max",
                            familyName: "Verstappen",
                            dateOfBirth: "1997-13-30",
                            nationality: "Dutch"
                        )
                    ]
                )
            )
        )

        // When
        do {
            _ = try response.toPage()
            Issue.record("Expected DataError.mapping to be thrown")
        } catch let error as DataError {
            // Then
            #expect(error == .mapping(underlying: "Invalid dateOfBirth: 1997-13-30"))
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test("DriversResponseDTO should map invalid wikipedia URL strings to nil")
    func testDriversMappingInvalidURLToNil() throws {
        // Given
        let response = DriversResponseDTO(
            mrData: .init(
                total: "24",
                limit: "2",
                offset: "0",
                driverTable: .init(
                    season: "2023",
                    drivers: [
                        .init(
                            driverId: "max_verstappen",
                            url: "https://exa mple.com",
                            givenName: "Max",
                            familyName: "Verstappen",
                            dateOfBirth: "1997-09-30",
                            nationality: "Dutch"
                        )
                    ]
                )
            )
        )

        // When
        let page = try response.toPage()

        // Then
        #expect(page.items[0].wikipediaURL == nil)
    }
}
