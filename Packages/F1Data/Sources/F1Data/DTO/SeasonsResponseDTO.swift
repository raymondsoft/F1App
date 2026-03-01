import Foundation

struct SeasonsResponseDTO: Decodable {
    let mrData: MRData

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }

    struct MRData: Decodable {
        let limit: String?
        let offset: String?
        let total: String?
        let seasonTable: SeasonTable

        enum CodingKeys: String, CodingKey {
            case limit
            case offset
            case total
            case seasonTable = "SeasonTable"
        }

        struct SeasonTable: Decodable {
            let seasons: [Season]

            enum CodingKeys: String, CodingKey {
                case seasons = "Seasons"
            }

            struct Season: Decodable {
                let season: String
                let url: String
            }
        }
    }
}
