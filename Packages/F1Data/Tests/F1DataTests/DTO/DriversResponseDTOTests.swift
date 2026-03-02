import Foundation
import Testing
@testable import F1Data

@Suite
struct DriversResponseDTOTests {
    @Test("DriversResponseDTO should decode drivers fixture and pagination metadata")
    func testDriversFixtureDecoding() throws {
        // Given
        let data = try loadJSONFixture(named: "drivers_2023")
        let decoder = JSONDecoder()

        // When
        let response = try decoder.decode(DriversResponseDTO.self, from: data)

        // Then
        #expect(response.mrData.total == "24")
        #expect(response.mrData.limit == "2")
        #expect(response.mrData.offset == "0")
        #expect(response.mrData.driverTable.season == "2023")
        #expect(response.mrData.driverTable.drivers.count == 2)
        #expect(response.mrData.driverTable.drivers[0].driverId == "max_verstappen")
    }
}
