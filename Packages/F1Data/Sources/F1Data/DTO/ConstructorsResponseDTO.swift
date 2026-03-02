import Foundation

struct ConstructorsResponseDTO: Decodable {
    let mrData: MRData

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }

    struct MRData: Decodable {
        let total: String?
        let limit: String?
        let offset: String?
        let constructorTable: ConstructorTable

        enum CodingKeys: String, CodingKey {
            case total
            case limit
            case offset
            case constructorTable = "ConstructorTable"
        }

        struct ConstructorTable: Decodable {
            let season: String
            let constructors: [Constructor]

            enum CodingKeys: String, CodingKey {
                case season
                case constructors = "Constructors"
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
