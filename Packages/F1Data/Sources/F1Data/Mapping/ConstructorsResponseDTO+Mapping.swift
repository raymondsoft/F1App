import Foundation
import F1Domain

extension ConstructorsResponseDTO {
    func toPage() throws -> Page<Constructor> {
        let metadata = try JolpicaMappingSupport.makePaginationMetadata(
            total: mrData.total,
            limit: mrData.limit,
            offset: mrData.offset
        )

        return try Page(
            items: mrData.constructorTable.constructors.map { constructor in
                JolpicaMappingSupport.makeConstructor(
                    id: constructor.constructorId,
                    name: constructor.name,
                    nationality: constructor.nationality,
                    url: constructor.url
                )
            },
            total: metadata.total,
            limit: metadata.limit,
            offset: metadata.offset
        )
    }
}
