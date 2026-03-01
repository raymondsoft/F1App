import Testing
@testable import F1Domain

@Suite
struct PageRequestTests {
    @Test("Page requests with the same values are equal and hash the same")
    func pageRequestsWithSameValuesAreEqual() {
        // Given
        let firstRequest = PageRequest(limit: 20, offset: 40)
        let secondRequest = PageRequest(limit: 20, offset: 40)

        // When
        let requests = Set([firstRequest, secondRequest])

        // Then
        #expect(firstRequest == secondRequest)
        #expect(requests.count == 1)
    }
}
