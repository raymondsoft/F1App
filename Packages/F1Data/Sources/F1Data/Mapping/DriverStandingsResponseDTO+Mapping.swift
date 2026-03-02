import Foundation
import F1Domain

extension DriverStandingsResponseDTO {
    func toPage() throws -> Page<DriverStanding> {
        let metadata = try JolpicaMappingSupport.makePaginationMetadata(
            total: mrData.total,
            limit: mrData.limit,
            offset: mrData.offset
        )

        let items = try mrData.standingsTable.standingsLists.flatMap { standingsList in
            try standingsList.driverStandings.map { standing in
                DriverStanding(
                    seasonId: Season.ID(rawValue: standingsList.season),
                    position: try JolpicaMappingSupport.parseOptionalInt(standing.position, label: "position"),
                    points: try JolpicaMappingSupport.parseRequiredDouble(standing.points, label: "points"),
                    wins: try JolpicaMappingSupport.parseRequiredInt(standing.wins, label: "wins"),
                    driver: try JolpicaMappingSupport.makeDriver(
                        id: standing.driver.driverId,
                        givenName: standing.driver.givenName,
                        familyName: standing.driver.familyName,
                        dateOfBirth: standing.driver.dateOfBirth,
                        nationality: standing.driver.nationality,
                        url: standing.driver.url
                    ),
                    constructors: standing.constructors.map { constructor in
                        JolpicaMappingSupport.makeConstructor(
                            id: constructor.constructorId,
                            name: constructor.name,
                            nationality: constructor.nationality,
                            url: constructor.url
                        )
                    }
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
