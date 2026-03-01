import Testing
@testable import F1Domain

@Suite
struct PageTests {
    @Test("Page reports more items when total is greater than the consumed item count")
    func pageReportsMoreItemsWhenTotalIsGreaterThanConsumedCount() throws {
        // Given
        let page = try Page(
            items: [1, 2],
            total: 5,
            limit: 2,
            offset: 0
        )

        // When
        let hasMore = page.hasMore

        // Then
        #expect(hasMore == true)
    }

    @Test("Page reports no more items when total is fully consumed")
    func pageReportsNoMoreItemsWhenTotalIsConsumed() throws {
        // Given
        let page = try Page(
            items: [3, 4],
            total: 4,
            limit: 2,
            offset: 2
        )

        // When
        let hasMore = page.hasMore

        // Then
        #expect(hasMore == false)
    }

    @Test("Page reports more items without total only when item count fills the limit")
    func pageReportsMoreItemsWithoutTotalOnlyWhenItemCountMatchesLimit() throws {
        // Given
        let page = try Page(
            items: [1, 2, 3],
            total: nil,
            limit: 3,
            offset: 6
        )

        // When
        let hasMore = page.hasMore

        // Then
        #expect(hasMore == true)
    }

    @Test("Page reports no more items without total when item count is below the limit")
    func pageReportsNoMoreItemsWithoutTotalWhenItemCountIsBelowLimit() throws {
        // Given
        let page = try Page(
            items: [1],
            total: nil,
            limit: 3,
            offset: 6
        )

        // When
        let hasMore = page.hasMore

        // Then
        #expect(hasMore == false)
    }

    @Test("Pages with the same values are equal and hash the same")
    func pagesWithSameValuesAreEqual() throws {
        // Given
        let firstPage = try Page(
            items: [1, 2, 3],
            total: 10,
            limit: 3,
            offset: 0
        )
        let secondPage = try Page(
            items: [1, 2, 3],
            total: 10,
            limit: 3,
            offset: 0
        )

        // When
        let pages = Set([firstPage, secondPage])

        // Then
        #expect(firstPage == secondPage)
        #expect(pages.count == 1)
    }

    @Test("Page rejects non-positive limits")
    func pageRejectsNonPositiveLimits() {
        // Given
        let invalidLimit = 0

        // When
        let thrownError = #expect(throws: PaginationError.self) {
            try Page(
                items: [1],
                total: nil,
                limit: invalidLimit,
                offset: 0
            )
        }

        // Then
        #expect(thrownError == .invalidLimit)
    }

    @Test("Page rejects negative offsets")
    func pageRejectsNegativeOffsets() {
        // Given
        let invalidOffset = -1

        // When
        let thrownError = #expect(throws: PaginationError.self) {
            try Page(
                items: [1],
                total: nil,
                limit: 1,
                offset: invalidOffset
            )
        }

        // Then
        #expect(thrownError == .invalidOffset)
    }

    @Test("Page rejects negative totals")
    func pageRejectsNegativeTotals() {
        // Given
        let invalidTotal = -1

        // When
        let thrownError = #expect(throws: PaginationError.self) {
            try Page(
                items: [1],
                total: invalidTotal,
                limit: 1,
                offset: 0
            )
        }

        // Then
        #expect(thrownError == .invalidTotal)
    }
}
