//
//  SurveyAppUITests.swift
//  SurveyAppUITests
//
//  Created by Asif on 19/3/22.
//

import XCTest
import SurveyApp

class SurveyAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppUI() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let arrowButton = app.buttons["arrowBtnIdentifier"]
        if(arrowButton.exists == true){
            XCTAssertTrue(arrowButton.exists)
            sleep(60)
            let title = app.staticTexts.element(matching:.any, identifier: "cellDataTitleAccIdentifier").label
            XCTAssertTrue(title.count > 0, "")
            //XCTAssertEqual(app.staticTexts.element(matching:.any, identifier: "cellDataTitleAccIdentifier").label, "89")
        }
        else{
            let loginButton = app.buttons["loginButtonAccesibilityIdentifier"]
            let emailTextField = app.textFields["emailTextFieldAccesibilityIdentifier"]
            XCTAssertTrue(loginButton.exists)
            XCTAssertTrue(emailTextField.exists)
            loginButton.tap()
            let alert = app.alerts["loginAlertId"]
            XCTAssertTrue(alert.exists)

        }
        app.terminate()
        
    }
}
