//
//  Machine__Learning_I_mage_RecognitionUITestsLaunchTests.swift
//  Machine -Learning-İmage-RecognitionUITests
//
//  Created by Sabri Çetin on 16.07.2024.
//

import XCTest

final class Machine__Learning_I_mage_RecognitionUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
