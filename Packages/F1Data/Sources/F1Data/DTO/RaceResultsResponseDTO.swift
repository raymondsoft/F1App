import Foundation

struct RaceResultsResponseDTO: Decodable {
    let mrData: MRData

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }

    struct MRData: Decodable {
        let total: String?
        let limit: String?
        let offset: String?
        let raceTable: RaceTable

        enum CodingKeys: String, CodingKey {
            case total
            case limit
            case offset
            case raceTable = "RaceTable"
        }

        struct RaceTable: Decodable {
            let season: String
            let round: String
            let races: [Race]

            enum CodingKeys: String, CodingKey {
                case season
                case round
                case races = "Races"
            }

            struct Race: Decodable {
                let season: String
                let round: String
                let raceName: String
                let date: String
                let time: String?
                let results: [Result]

                enum CodingKeys: String, CodingKey {
                    case season
                    case round
                    case raceName
                    case date
                    case time
                    case results = "Results"
                }

                struct Result: Decodable {
                    let position: String?
                    let positionText: String
                    let points: String
                    let driver: Driver
                    let constructor: Constructor
                    let grid: String?
                    let laps: String?
                    let status: String
                    let time: Time?

                    enum CodingKeys: String, CodingKey {
                        case position
                        case positionText
                        case points
                        case driver = "Driver"
                        case constructor = "Constructor"
                        case grid
                        case laps
                        case status
                        case time = "Time"
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

                    struct Time: Decodable {
                        let time: String
                    }
                }
            }
        }
    }
}
