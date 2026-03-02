import Foundation

struct DriverStandingsResponseDTO: Decodable {
    let mrData: MRData

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }

    struct MRData: Decodable {
        let total: String?
        let limit: String?
        let offset: String?
        let standingsTable: StandingsTable

        enum CodingKeys: String, CodingKey {
            case total
            case limit
            case offset
            case standingsTable = "StandingsTable"
        }

        struct StandingsTable: Decodable {
            let season: String
            let standingsLists: [StandingsList]

            enum CodingKeys: String, CodingKey {
                case season
                case standingsLists = "StandingsLists"
            }

            struct StandingsList: Decodable {
                let season: String
                let driverStandings: [DriverStanding]

                enum CodingKeys: String, CodingKey {
                    case season
                    case driverStandings = "DriverStandings"
                }

                struct DriverStanding: Decodable {
                    let position: String?
                    let points: String
                    let wins: String
                    let driver: Driver
                    let constructors: [Constructor]

                    enum CodingKeys: String, CodingKey {
                        case position
                        case points
                        case wins
                        case driver = "Driver"
                        case constructors = "Constructors"
                    }

                    struct Driver: Decodable {
                        let driverId: String
                        let url: String
                        let givenName: String
                        let familyName: String
                        let dateOfBirth: String?
                        let nationality: String
                    }

                    struct Constructor: Decodable {
                        let constructorId: String
                        let url: String
                        let name: String
                        let nationality: String
                    }
                }
            }
        }
    }
}
