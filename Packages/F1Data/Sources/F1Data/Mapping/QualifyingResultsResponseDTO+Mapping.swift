import Foundation
import F1Domain

extension QualifyingResultsResponseDTO {
    func toPage() throws -> Page<QualifyingResult> {
        let metadata = try JolpicaMappingSupport.makePaginationMetadata(
            total: mrData.total,
            limit: mrData.limit,
            offset: mrData.offset
        )

        let items = try mrData.raceTable.races.flatMap { race in
            try race.qualifyingResults.map { result in
                QualifyingResult(
                    seasonId: Season.ID(rawValue: race.season),
                    round: Race.Round(rawValue: race.round),
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
                    position: try JolpicaMappingSupport.parseOptionalInt(result.position, label: "position"),
                    q1: JolpicaMappingSupport.makeQualifyingLapTime(result.q1),
                    q2: JolpicaMappingSupport.makeQualifyingLapTime(result.q2),
                    q3: JolpicaMappingSupport.makeQualifyingLapTime(result.q3)
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
