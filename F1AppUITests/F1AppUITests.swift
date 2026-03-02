import XCTest

final class F1AppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunchShowsSeasonsEntryScreen() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(
            app.staticTexts["Seasons"].waitForExistence(timeout: 5),
            "The app should launch on the seasons entry screen."
        )
    }

    @MainActor
    func testRelaunchStillShowsSeasonsEntryScreen() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(
            app.staticTexts["Seasons"].waitForExistence(timeout: 5),
            "The first launch should reach the seasons entry screen."
        )

        app.terminate()
        app.launch()

        XCTAssertTrue(
            app.staticTexts["Seasons"].waitForExistence(timeout: 5),
            "Relaunching the app should still reach the seasons entry screen."
        )
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
