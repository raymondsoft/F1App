import Foundation

public struct Season: Hashable, Sendable {
    public struct ID: RawRepresentable, Hashable, Sendable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    public let id: ID
    public let wikipediaURL: URL?

    public init(id: ID, wikipediaURL: URL?) {
        self.id = id
        self.wikipediaURL = wikipediaURL
    }
}
