import Testing
@testable import F1Domain

@Suite
struct RaceResultTimeTests {
    @Test("Race result time values compare equally and hash the same")
    func raceResultTimeValuesCompareEqually() {
        // Given
        let firstTime = RaceResultTime.time("1:32:03.897")
        let secondTime = RaceResultTime.time("1:32:03.897")

        // When
        let times = Set([firstTime, secondTime])

        // Then
        #expect(firstTime == secondTime)
        #expect(times.count == 1)
    }

    @Test("Race result status values compare equally and hash the same")
    func raceResultStatusValuesCompareEqually() {
        // Given
        let firstStatus = RaceResultTime.status("Retired")
        let secondStatus = RaceResultTime.status("Retired")

        // When
        let statuses = Set([firstStatus, secondStatus])

        // Then
        #expect(firstStatus == secondStatus)
        #expect(statuses.count == 1)
    }
}
