import Foundation

public struct SeasonsResponseDTO: Decodable {
    public let mrData: MRDataDTO

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

public struct MRDataDTO: Decodable {
    public let seasonTable: SeasonTableDTO

    enum CodingKeys: String, CodingKey {
        case seasonTable = "SeasonTable"
    }
}

public struct SeasonTableDTO: Decodable {
    public let seasons: [SeasonDTO]

    enum CodingKeys: String, CodingKey {
        case seasons = "Seasons"
    }
}

public struct SeasonDTO: Decodable {
    public let season: String
    public let url: String
}
