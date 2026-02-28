@testable import F1Domain

extension Location {
    static func fixture(
        latitude: Double = 26.0325,
        longitude: Double = 50.5106,
        locality: String = "Sakhir",
        country: String = "Bahrain"
    ) -> Location {
        Location(
            latitude: latitude,
            longitude: longitude,
            locality: locality,
            country: country
        )
    }
}
