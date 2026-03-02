import Foundation

struct QualifyingResultsResponseDTO: Decodable {
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
                let qualifyingResults: [QualifyingResult]

                enum CodingKeys: String, CodingKey {
                    case season
                    case round
                    case qualifyingResults = "QualifyingResults"
                }

                struct QualifyingResult: Decodable {
                    let position: String?
                    let driver: Driver
                    let constructor: Constructor
                    let q1: String?
                    let q2: String?
                    let q3: String?

                    enum CodingKeys: String, CodingKey {
                        case position
                        case driver = "Driver"
                        case constructor = "Constructor"
                        case q1 = "Q1"
                        case q2 = "Q2"
                        case q3 = "Q3"
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
