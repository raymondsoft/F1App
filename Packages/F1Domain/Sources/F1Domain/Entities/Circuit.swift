import Foundation

public struct Circuit: Hashable, Sendable {
    public struct ID: RawRepresentable, Hashable, Sendable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    public let id: ID
    public let name: String
    public let wikipediaURL: URL?
    public let location: Location

    public init(
        id: ID,
        name: String,
        wikipediaURL: URL?,
        location: Location
    ) {
        self.id = id
        self.name = name
        self.wikipediaURL = wikipediaURL
        self.location = location
    }
}
