import Foundation
import F1Domain

extension RacesResponseDTO {
    func toDomain() throws -> [Race] {
        try mrData.raceTable.races.map { race in
            Race(
                seasonId: Season.ID(rawValue: race.season),
                round: Race.Round(rawValue: race.round),
                name: race.raceName,
                date: try parseDate(race.date),
                time: try parseTime(race.time),
                wikipediaURL: URL(string: race.url),
                circuit: Circuit(
                    id: Circuit.ID(rawValue: race.circuit.circuitId),
                    name: race.circuit.circuitName,
                    wikipediaURL: URL(string: race.circuit.url),
                    location: Location(
                        latitude: try parseCoordinate(
                            race.circuit.location.latitude,
                            label: "latitude"
                        ),
                        longitude: try parseCoordinate(
                            race.circuit.location.longitude,
                            label: "longitude"
                        ),
                        locality: race.circuit.location.locality,
                        country: race.circuit.location.country
                    )
                )
            )
        }
    }

    private func parseCoordinate(_ value: String, label: String) throws -> Double {
        guard let coordinate = Double(value) else {
            throw DataError.mapping(underlying: "Invalid \(label): \(value)")
        }

        return coordinate
    }

    private func parseDate(_ value: String) throws -> Date {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.isLenient = false

        guard let date = formatter.date(from: value) else {
            throw DataError.mapping(underlying: "Invalid date: \(value)")
        }

        return date
    }

    private func parseTime(_ value: String?) throws -> Race.Time? {
        guard let value else {
            return nil
        }

        guard value.count >= 8 else {
            throw DataError.mapping(underlying: "Invalid time: \(value)")
        }

        let timePart = String(value.prefix(8))
        let components = timePart.split(separator: ":")

        guard
            components.count == 3,
            let hour = Int(components[0]),
            let minute = Int(components[1]),
            let second = Int(components[2]),
            (0...23).contains(hour),
            (0...59).contains(minute),
            (0...59).contains(second)
        else {
            throw DataError.mapping(underlying: "Invalid time: \(value)")
        }

        let offsetPart = String(value.dropFirst(8))
        let utcOffsetSeconds = try parseUTCOffsetSeconds(offsetPart, originalValue: value)

        return Race.Time(
            hour: hour,
            minute: minute,
            second: second,
            utcOffsetSeconds: utcOffsetSeconds
        )
    }

    private func parseUTCOffsetSeconds(_ value: String, originalValue: String) throws -> Int {
        if value.isEmpty || value == "Z" {
            return 0
        }

        guard value.count == 6 else {
            throw DataError.mapping(underlying: "Invalid time: \(originalValue)")
        }

        guard let sign = value.first, sign == "+" || sign == "-" else {
            throw DataError.mapping(underlying: "Invalid time: \(originalValue)")
        }

        let parts = value.dropFirst().split(separator: ":")

        guard
            parts.count == 2,
            let hours = Int(parts[0]),
            let minutes = Int(parts[1]),
            (0...23).contains(hours),
            (0...59).contains(minutes)
        else {
            throw DataError.mapping(underlying: "Invalid time: \(originalValue)")
        }

        let totalSeconds = (hours * 3600) + (minutes * 60)
        return sign == "-" ? -totalSeconds : totalSeconds
    }
}
