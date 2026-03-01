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

    func toPage() throws -> Page<Season> {
        let metadata = try PaginationMetadata(
            total: mrData.total,
            limit: mrData.limit,
            offset: mrData.offset
        )

        return try Page(
            items: toDomain(),
            total: metadata.total,
            limit: metadata.limit,
            offset: metadata.offset
        )
    }
}
