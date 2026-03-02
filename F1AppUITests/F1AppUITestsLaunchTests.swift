import XCTest

final class F1AppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(
            app.staticTexts["Seasons"].waitForExistence(timeout: 5),
            "The launch flow should arrive on the seasons entry screen."
        )

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Seasons Entry Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
