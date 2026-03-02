import Foundation
import F1Domain

enum JolpicaMappingSupport {
    static func makeDriver(
        id: String,
        givenName: String,
        familyName: String,
        dateOfBirth: String?,
        nationality: String,
        url: String
    ) throws -> Driver {
        Driver(
            id: Driver.ID(rawValue: id),
            givenName: givenName,
            familyName: familyName,
            dateOfBirth: try parseDateOfBirth(dateOfBirth),
            nationality: nationality,
            wikipediaURL: URL(string: url)
        )
    }

    static func makeConstructor(
        id: String,
        name: String,
        nationality: String,
        url: String
    ) -> Constructor {
        Constructor(
            id: Constructor.ID(rawValue: id),
            name: name,
            nationality: nationality,
            wikipediaURL: URL(string: url)
        )
    }

    static func parseRequiredInt(_ value: String, label: String) throws -> Int {
        guard let parsedValue = Int(value) else {
            throw DataError.mapping(underlying: "Invalid \(label): \(value)")
        }

        return parsedValue
    }

    static func parseOptionalInt(_ value: String?, label: String) throws -> Int? {
        guard let value, !value.isEmpty else {
            return nil
        }

        return try parseRequiredInt(value, label: label)
    }

    static func parseRequiredDouble(_ value: String, label: String) throws -> Double {
        guard let parsedValue = Double(value) else {
            throw DataError.mapping(underlying: "Invalid \(label): \(value)")
        }

        return parsedValue
    }

    static func parseCoordinate(_ value: String, label: String) throws -> Double {
        guard let parsedValue = Double(value) else {
            throw DataError.mapping(underlying: "Invalid \(label): \(value)")
        }

        return parsedValue
    }

    static func parseDate(_ value: String, label: String = "date") throws -> Date {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.isLenient = false

        guard let date = formatter.date(from: value) else {
            throw DataError.mapping(underlying: "Invalid \(label): \(value)")
        }

        return date
    }

    static func parseDateOfBirth(_ value: String?) throws -> Date? {
        guard let value, !value.isEmpty else {
            return nil
        }

        return try parseDate(value, label: "dateOfBirth")
    }

    static func parseRaceTime(_ value: String?) throws -> Race.Time? {
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

    static func makeRaceResultTime(timeValue: String?, statusValue: String) -> RaceResultTime? {
        let rawValue = timeValue ?? statusValue

        guard !rawValue.isEmpty else {
            return nil
        }

        let containsDigit = rawValue.rangeOfCharacter(from: .decimalDigits) != nil
        let looksLikeTime = containsDigit && (rawValue.contains(":") || rawValue.contains("."))

        if looksLikeTime {
            return .time(rawValue)
        }

        return .status(rawValue)
    }

    static func makeQualifyingLapTime(_ value: String?) -> QualifyingLapTime? {
        guard let value, !value.isEmpty else {
            return nil
        }

        return QualifyingLapTime(rawValue: value)
    }

    static func makeLocation(
        latitude: String,
        longitude: String,
        locality: String,
        country: String
    ) throws -> Location {
        Location(
            latitude: try parseCoordinate(latitude, label: "latitude"),
            longitude: try parseCoordinate(longitude, label: "longitude"),
            locality: locality,
            country: country
        )
    }

    static func makePaginationMetadata(
        total: String?,
        limit: String?,
        offset: String?
    ) throws -> PaginationMetadata {
        try PaginationMetadata(total: total, limit: limit, offset: offset)
    }

    private static func parseUTCOffsetSeconds(_ value: String, originalValue: String) throws -> Int {
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
