import Foundation

public struct Driver: Hashable, Sendable {
    public struct ID: RawRepresentable, Hashable, Sendable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    public let id: ID
    public let givenName: String
    public let familyName: String
    public let dateOfBirth: Date?
    public let nationality: String
    public let wikipediaURL: URL?

    public init(
        id: ID,
        givenName: String,
        familyName: String,
        dateOfBirth: Date?,
        nationality: String,
        wikipediaURL: URL?
    ) {
        self.id = id
        self.givenName = givenName
        self.familyName = familyName
        self.dateOfBirth = dateOfBirth
        self.nationality = nationality
        self.wikipediaURL = wikipediaURL
    }
}
