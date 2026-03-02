import Foundation

struct DriversResponseDTO: Decodable {
    let mrData: MRData

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }

    struct MRData: Decodable {
        let total: String?
        let limit: String?
        let offset: String?
        let driverTable: DriverTable

        enum CodingKeys: String, CodingKey {
            case total
            case limit
            case offset
            case driverTable = "DriverTable"
        }

        struct DriverTable: Decodable {
            let season: String
            let drivers: [Driver]

            enum CodingKeys: String, CodingKey {
                case season
                case drivers = "Drivers"
            }

            struct Driver: Decodable {
                let driverId: String
                let url: String
                let givenName: String
                let familyName: String
                let dateOfBirth: String?
                let nationality: String
            }
        }
    }
}
