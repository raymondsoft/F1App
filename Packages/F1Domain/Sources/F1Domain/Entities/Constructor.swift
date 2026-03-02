import Foundation

public struct Constructor: Hashable, Sendable {
    public struct ID: RawRepresentable, Hashable, Sendable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    public let id: ID
    public let name: String
    public let nationality: String
    public let wikipediaURL: URL?

    public init(
        id: ID,
        name: String,
        nationality: String,
        wikipediaURL: URL?
    ) {
        self.id = id
        self.name = name
        self.nationality = nationality
        self.wikipediaURL = wikipediaURL
    }
}
