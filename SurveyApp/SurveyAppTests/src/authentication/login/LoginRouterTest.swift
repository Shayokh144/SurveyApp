//
//  LoginRouterTest.swift
//  SurveyAppTests
//
//  Created by Asif on 22/3/22.
//

import XCTest
@testable import SurveyApp

class LoginRouterTest: XCTestCase {
    func testViewController(){
        let vc = LoginRouter.createModule()
        XCTAssertNotNil(vc)
    }
}
