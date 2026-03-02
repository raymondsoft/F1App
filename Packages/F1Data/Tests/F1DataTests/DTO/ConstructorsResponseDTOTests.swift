import Foundation
import Testing
@testable import F1Data

@Suite
struct ConstructorsResponseDTOTests {
    @Test("ConstructorsResponseDTO should decode constructors fixture and pagination metadata")
    func testConstructorsFixtureDecoding() throws {
        // Given
        let data = try loadJSONFixture(named: "constructors_2023")
        let decoder = JSONDecoder()

        // When
        let response = try decoder.decode(ConstructorsResponseDTO.self, from: data)

        // Then
        #expect(response.mrData.total == "10")
        #expect(response.mrData.limit == "2")
        #expect(response.mrData.offset == "0")
        #expect(response.mrData.constructorTable.season == "2023")
        #expect(response.mrData.constructorTable.constructors[0].constructorId == "red_bull")
    }
}
