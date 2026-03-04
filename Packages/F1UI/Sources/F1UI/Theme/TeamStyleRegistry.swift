public enum TeamStyleToken: Hashable, Sendable {
    case ferrari
    case mercedes
    case redBull
    case mclaren
    case astonMartin
    case alpine
    case williams
    case haas
    case rb
    case sauber
}

public struct TeamStyle: Hashable, Sendable {
    public let token: TeamStyleToken
    public let shortCode: String

    public init(token: TeamStyleToken, shortCode: String) {
        self.token = token
        self.shortCode = shortCode
    }
}

public enum TeamStyleRegistry {
    public static func style(for constructorId: String) -> TeamStyle? {
        switch constructorId.lowercased() {
        case "ferrari":
            return TeamStyle(token: .ferrari, shortCode: "FER")
        case "mercedes":
            return TeamStyle(token: .mercedes, shortCode: "MER")
        case "red_bull", "redbull":
            return TeamStyle(token: .redBull, shortCode: "RBR")
        case "mclaren":
            return TeamStyle(token: .mclaren, shortCode: "MCL")
        case "aston_martin", "astonmartin":
            return TeamStyle(token: .astonMartin, shortCode: "AMR")
        case "alpine":
            return TeamStyle(token: .alpine, shortCode: "ALP")
        case "williams":
            return TeamStyle(token: .williams, shortCode: "WIL")
        case "haas":
            return TeamStyle(token: .haas, shortCode: "HAA")
        case "rb", "alphatauri", "racing_bulls":
            return TeamStyle(token: .rb, shortCode: "RB")
        case "sauber", "kick_sauber":
            return TeamStyle(token: .sauber, shortCode: "SAU")
        default:
            return nil
        }
    }
}
