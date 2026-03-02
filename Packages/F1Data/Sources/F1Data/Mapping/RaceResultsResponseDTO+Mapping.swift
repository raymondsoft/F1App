import Foundation
import F1Domain

extension RaceResultsResponseDTO {
    func toPage() throws -> Page<RaceResult> {
        let metadata = try JolpicaMappingSupport.makePaginationMetadata(
            total: mrData.total,
            limit: mrData.limit,
            offset: mrData.offset
        )

        let items = try mrData.raceTable.races.flatMap { race in
            try race.results.map { result in
                RaceResult(
                    seasonId: Season.ID(rawValue: race.season),
                    round: Race.Round(rawValue: race.round),
                    raceName: race.raceName,
                    date: try JolpicaMappingSupport.parseDate(race.date),
                    time: try JolpicaMappingSupport.parseRaceTime(race.time),
                    driver: try JolpicaMappingSupport.makeDriver(
                        id: result.driver.driverId,
                        givenName: result.driver.givenName,
                        familyName: result.driver.familyName,
                        dateOfBirth: result.driver.dateOfBirth,
                        nationality: result.driver.nationality,
                        url: result.driver.url
                    ),
                    constructor: JolpicaMappingSupport.makeConstructor(
                        id: result.constructor.constructorId,
                        name: result.constructor.name,
                        nationality: result.constructor.nationality,
                        url: result.constructor.url
                    ),
                    grid: try JolpicaMappingSupport.parseOptionalInt(result.grid, label: "grid"),
                    position: try JolpicaMappingSupport.parseOptionalInt(result.position, label: "position"),
                    positionText: result.positionText,
                    points: try JolpicaMappingSupport.parseRequiredDouble(result.points, label: "points"),
                    laps: try JolpicaMappingSupport.parseOptionalInt(result.laps, label: "laps"),
                    status: result.status,
                    resultTime: JolpicaMappingSupport.makeRaceResultTime(
                        timeValue: result.time?.time,
                        statusValue: result.status
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
