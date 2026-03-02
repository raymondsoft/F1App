import Foundation
import F1Domain

extension RacesResponseDTO {
    func toDomain() throws -> [Race] {
        try mrData.raceTable.races.map { race in
            Race(
                seasonId: Season.ID(rawValue: race.season),
                round: Race.Round(rawValue: race.round),
                name: race.raceName,
                date: try JolpicaMappingSupport.parseDate(race.date),
                time: try JolpicaMappingSupport.parseRaceTime(race.time),
                wikipediaURL: URL(string: race.url),
                circuit: Circuit(
                    id: Circuit.ID(rawValue: race.circuit.circuitId),
                    name: race.circuit.circuitName,
                    wikipediaURL: URL(string: race.circuit.url),
                    location: try JolpicaMappingSupport.makeLocation(
                        latitude: race.circuit.location.latitude,
                        longitude: race.circuit.location.longitude,
                        locality: race.circuit.location.locality,
                        country: race.circuit.location.country
                    )
                )
            )
        }
    }

    func toPage() throws -> Page<Race> {
        let metadata = try JolpicaMappingSupport.makePaginationMetadata(
            total: mrData.total,
            limit: mrData.limit,
            offset: mrData.offset
        )

        return try Page(
            items: try toDomain(),
            total: metadata.total,
            limit: metadata.limit,
            offset: metadata.offset
        )
    }
}
