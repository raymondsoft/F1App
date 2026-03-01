import Testing
@testable import F1Domain

@Suite
struct PageTests {
    @Test("Page reports more items when total is greater than the consumed item count")
    func pageReportsMoreItemsWhenTotalIsGreaterThanConsumedCount() {
        // Given
        let page = Page(
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
    func pageReportsNoMoreItemsWhenTotalIsConsumed() {
        // Given
        let page = Page(
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
    func pageReportsMoreItemsWithoutTotalOnlyWhenItemCountMatchesLimit() {
        // Given
        let page = Page(
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
    func pageReportsNoMoreItemsWithoutTotalWhenItemCountIsBelowLimit() {
        // Given
        let page = Page(
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
    func pagesWithSameValuesAreEqual() {
        // Given
        let firstPage = Page(
            items: [1, 2, 3],
            total: 10,
            limit: 3,
            offset: 0
        )
        let secondPage = Page(
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
}
