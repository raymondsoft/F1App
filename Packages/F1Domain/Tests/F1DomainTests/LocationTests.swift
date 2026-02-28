import Testing
@testable import F1Domain

@Suite
struct LocationTests {
    @Test("Locations with the same values are equal and hash the same")
    func locationsWithSameValuesAreEqual() {
        // Given
        let firstLocation = Location(
            latitude: 43.7347,
            longitude: 7.4206,
            locality: "Monte-Carlo",
            country: "Monaco"
        )
        let secondLocation = Location(
            latitude: 43.7347,
            longitude: 7.4206,
            locality: "Monte-Carlo",
            country: "Monaco"
        )

        // When
        let locations = Set([firstLocation, secondLocation])

        // Then
        #expect(firstLocation == secondLocation)
        #expect(locations.count == 1)
    }
}
