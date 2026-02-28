public struct Location: Hashable, Sendable {
    public let latitude: Double
    public let longitude: Double
    public let locality: String
    public let country: String

    public init(
        latitude: Double,
        longitude: Double,
        locality: String,
        country: String
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.locality = locality
        self.country = country
    }
}
