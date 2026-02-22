import Foundation
import Testing

func loadJSONFixture(named name: String) throws -> Data {
    let fixtureURL = try #require(Bundle.module.url(forResource: name, withExtension: "json"))
    return try Data(contentsOf: fixtureURL)
}
