import Foundation
import F1Domain

extension DriversResponseDTO {
    func toPage() throws -> Page<Driver> {
        let metadata = try JolpicaMappingSupport.makePaginationMetadata(
            total: mrData.total,
            limit: mrData.limit,
            offset: mrData.offset
        )

        return try Page(
            items: try mrData.driverTable.drivers.map { driver in
                try JolpicaMappingSupport.makeDriver(
                    id: driver.driverId,
                    givenName: driver.givenName,
                    familyName: driver.familyName,
                    dateOfBirth: driver.dateOfBirth,
                    nationality: driver.nationality,
                    url: driver.url
                )
            },
            total: metadata.total,
            limit: metadata.limit,
            offset: metadata.offset
        )
    }
}
