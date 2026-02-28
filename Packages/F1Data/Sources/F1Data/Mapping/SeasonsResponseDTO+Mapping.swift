import Foundation
import F1Domain

extension SeasonsResponseDTO {
    func toDomain() -> [Season] {
        mrData.seasonTable.seasons.map { season in
            Season(
                id: Season.ID(rawValue: season.season),
                wikipediaURL: URL(string: season.url)
            )
        }
    }
}
