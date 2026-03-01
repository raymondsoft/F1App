import Testing
@testable import F1Domain

@Suite
struct PageRequestTests {
    @Test("Page requests with the same values are equal and hash the same")
    func pageRequestsWithSameValuesAreEqual() throws {
        // Given
        let firstRequest = try PageRequest(limit: 20, offset: 40)
        let secondRequest = try PageRequest(limit: 20, offset: 40)

        // When
        let requests = Set([firstRequest, secondRequest])

        // Then
        #expect(firstRequest == secondRequest)
        #expect(requests.count == 1)
    }

    @Test("Page request rejects non-positive limits")
    func pageRequestRejectsNonPositiveLimits() {
        // Given
        let invalidLimit = 0

        // When
        let thrownError = #expect(throws: PaginationError.self) {
            try PageRequest(limit: invalidLimit, offset: 0)
        }

        // Then
        #expect(thrownError == .invalidLimit)
    }

    @Test("Page request rejects negative offsets")
    func pageRequestRejectsNegativeOffsets() {
        // Given
        let invalidOffset = -1

        // When
        let thrownError = #expect(throws: PaginationError.self) {
            try PageRequest(limit: 20, offset: invalidOffset)
        }

        // Then
        #expect(thrownError == .invalidOffset)
    }
}
