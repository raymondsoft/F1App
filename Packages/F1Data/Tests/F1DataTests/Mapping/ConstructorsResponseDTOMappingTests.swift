import Foundation
import Testing
import F1Domain
@testable import F1Data

@Suite
struct ConstructorsResponseDTOMappingTests {
    @Test("ConstructorsResponseDTO should map constructors fixture to a paged domain response")
    func testConstructorsMapping() throws {
        // Given
        let data = try loadJSONFixture(named: "constructors_2023")
        let decoder = JSONDecoder()
        let response = try decoder.decode(ConstructorsResponseDTO.self, from: data)

        // When
        let page = try response.toPage()

        // Then
        #expect(page.items.count == 2)
        #expect(page.total == 10)
        #expect(page.hasMore == true)
        #expect(page.items[0].id == Constructor.ID(rawValue: "red_bull"))
        #expect(page.items[0].name == "Red Bull")
    }

    @Test("ConstructorsResponseDTO should throw mapping error for invalid pagination metadata")
    func testConstructorsMappingInvalidPagination() {
        // Given
        let response = ConstructorsResponseDTO(
            mrData: .init(
                total: "10",
                limit: "x",
                offset: "0",
                constructorTable: .init(
                    season: "2023",
                    constructors: []
                )
            )
        )

        // When
        do {
            _ = try response.toPage()
            Issue.record("Expected DataError.mapping to be thrown")
        } catch let error as DataError {
            // Then
            #expect(error == .mapping(underlying: "Invalid limit: x"))
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test("ConstructorsResponseDTO should map invalid wikipedia URL strings to nil")
    func testConstructorsMappingInvalidURLToNil() throws {
        // Given
        let response = ConstructorsResponseDTO(
            mrData: .init(
                total: "10",
                limit: "2",
                offset: "0",
                constructorTable: .init(
                    season: "2023",
                    constructors: [
                        .init(
                            constructorId: "red_bull",
                            url: "https://exa mple.com",
                            name: "Red Bull",
                            nationality: "Austrian"
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
