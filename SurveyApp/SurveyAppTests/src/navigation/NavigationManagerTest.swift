//
//  NavigationManagerTest.swift
//  SurveyAppTests
//
//  Created by Asif on 22/3/22.
//

import XCTest
@testable import SurveyApp

class NavigationManagerTest: XCTestCase {

    var sut : NavigationManager?
    override func setUpWithError() throws {
        sut = NavigationManager.shared
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testNavigationManager() {
        let navController = sut?.getCurrentNavigationController()
        sut?.setInitialView()
        XCTAssertNotNil(navController)
    }
}
