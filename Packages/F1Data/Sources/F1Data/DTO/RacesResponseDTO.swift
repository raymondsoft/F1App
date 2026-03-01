import Foundation

struct RacesResponseDTO: Decodable {
    let mrData: MRData

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }

    struct MRData: Decodable {
        let limit: String?
        let offset: String?
        let total: String?
        let raceTable: RaceTable

        enum CodingKeys: String, CodingKey {
            case limit
            case offset
            case total
            case raceTable = "RaceTable"
        }

        struct RaceTable: Decodable {
            let season: String
            let races: [Race]

            enum CodingKeys: String, CodingKey {
                case season
                case races = "Races"
            }

            struct Race: Decodable {
                let season: String
                let round: String
                let url: String
                let raceName: String
                let circuit: Circuit
                let date: String
                let time: String?

                enum CodingKeys: String, CodingKey {
                    case season
                    case round
                    case url
                    case raceName
                    case circuit = "Circuit"
                    case date
                    case time
                }

                struct Circuit: Decodable {
                    let circuitId: String
                    let url: String
                    let circuitName: String
                    let location: Location

                    enum CodingKeys: String, CodingKey {
                        case circuitId
                        case url
                        case circuitName
                        case location = "Location"
                    }

                    struct Location: Decodable {
                        let latitude: String
                        let longitude: String
                        let locality: String
                        let country: String

                        enum CodingKeys: String, CodingKey {
                            case latitude = "lat"
                            case longitude = "long"
                            case locality
                            case country
                        }
                    }
                }
            }
        }
    }
}
