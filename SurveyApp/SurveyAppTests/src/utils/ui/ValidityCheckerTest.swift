//
//  ValidityCheckerTest.swift
//  SurveyAppTests
//
//  Created by Asif on 22/3/22.
//

import XCTest
@testable import SurveyApp

class ValidityCheckerTest: XCTestCase {

    func testEmailValidity(){
        XCTAssertTrue(ValidityChecker.isValidEmail(address: "a@b.co"), "valid format given")
        XCTAssertFalse(ValidityChecker.isValidEmail(address: "ab.c"), "invalid format given")
    }
    
    func testPasswordValidity(){
        XCTAssertTrue(ValidityChecker.isValidPasswordFormat(password: "ds"), "no rules for password given")
        XCTAssertFalse(ValidityChecker.isValidPasswordFormat(password: ""), "no rules for password given")

    }

}
