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
        sleep(20)
        let arrowButton = app.buttons["arrowBtnIdentifier"]
        if(arrowButton.exists == true){
            XCTAssertTrue(arrowButton.exists)
            var title = app.staticTexts.element(matching:.any, identifier: "cellDataTitleAccIdentifier").label
            XCTAssertTrue(title.count > 0, "")
            arrowButton.tap()
            sleep(3)
            title = app.staticTexts.element(matching:.any, identifier: "surveyDetailsViewTitleAccesibilityIdentifier").label
            XCTAssertTrue(title.count > 0, "")
        }
        else{
            let loginButton = app.buttons["loginButtonAccesibilityIdentifier"]
            let emailTextField = app.textFields["emailTextFieldAccesibilityIdentifier"]
            let passwordTextField = app.secureTextFields["passwordTextFieldAccesibilityIdentifier"]
            
            XCTAssertTrue(loginButton.exists)
            XCTAssertTrue(emailTextField.exists)
            XCTAssertTrue(passwordTextField.exists)
            loginButton.tap()
            sleep(3)
            
            let alert = app.alerts["loginAlertId"]
            XCTAssertTrue(alert.exists)
            
            alert.buttons["OK"].tap()
            sleep(3)
            XCTAssertFalse(alert.exists)
            
            emailTextField.tap()
            emailTextField.typeText("dev@nimblehq.co")
            sleep(2)
            
            passwordTextField.tap()
            passwordTextField.typeText("12345678")
            sleep(2)
            
            loginButton.tap()
            
            sleep(10)
            
            let arrowBtn = app.buttons["arrowBtnIdentifier"]
            XCTAssertTrue(arrowBtn.exists)
        }
        app.terminate()
        
    }
}
