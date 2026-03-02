import Foundation
import F1Domain

extension ConstructorStandingsResponseDTO {
    func toPage() throws -> Page<ConstructorStanding> {
        let metadata = try JolpicaMappingSupport.makePaginationMetadata(
            total: mrData.total,
            limit: mrData.limit,
            offset: mrData.offset
        )

        let items = try mrData.standingsTable.standingsLists.flatMap { standingsList in
            try standingsList.constructorStandings.map { standing in
                ConstructorStanding(
                    seasonId: Season.ID(rawValue: standingsList.season),
                    position: try JolpicaMappingSupport.parseOptionalInt(standing.position, label: "position"),
                    points: try JolpicaMappingSupport.parseRequiredDouble(standing.points, label: "points"),
                    wins: try JolpicaMappingSupport.parseRequiredInt(standing.wins, label: "wins"),
                    constructor: JolpicaMappingSupport.makeConstructor(
                        id: standing.constructor.constructorId,
                        name: standing.constructor.name,
                        nationality: standing.constructor.nationality,
                        url: standing.constructor.url
                    )
                )
            }
        }

        return try Page(
            items: items,
            total: metadata.total,
            limit: metadata.limit,
            offset: metadata.offset
        )
    }
}
