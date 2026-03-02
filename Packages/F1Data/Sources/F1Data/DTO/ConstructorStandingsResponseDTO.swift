import Foundation

struct ConstructorStandingsResponseDTO: Decodable {
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
                let constructorStandings: [ConstructorStanding]

                enum CodingKeys: String, CodingKey {
                    case season
                    case constructorStandings = "ConstructorStandings"
                }

                struct ConstructorStanding: Decodable {
                    let position: String?
                    let points: String
                    let wins: String
                    let constructor: Constructor

                    enum CodingKeys: String, CodingKey {
                        case position
                        case points
                        case wins
                        case constructor = "Constructor"
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
