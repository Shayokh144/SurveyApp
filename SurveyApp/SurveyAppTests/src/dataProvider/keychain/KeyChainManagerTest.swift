//
//  KeyChainManagerTest.swift
//  SurveyAppTests
//
//  Created by Asif on 22/3/22.
//

import XCTest
@testable import SurveyApp

class KeyChainManagerTest: XCTestCase {

    var sut : KeyChainManager?
    let testData = "testDataToSave".data(using: .utf8)
    
    override func setUpWithError() throws {
        sut = KeyChainManager(service: "SurveyApp.TestKeyChain", account: "devNimble.Test")
        sut?.deleteLoginDataFromKeyChain()
    }

    override func tearDownWithError() throws {
        sut?.deleteLoginDataFromKeyChain()
        sut = nil
    }
    func saveTestData(){
        sut?.saveLoginDataInKeychain(data: testData ?? Data())
    }
    
    func testSave() {
        saveTestData()
        let newData = sut?.getLoginDataFromKeyChain()
        XCTAssertEqual(newData, testData)
    }
    
    func testGet(){
        var loginData = sut?.getLoginDataFromKeyChain()
        XCTAssertNil(loginData)
        saveTestData()
        loginData = sut?.getLoginDataFromKeyChain()
        XCTAssertNotNil(loginData)
    }

    func testUpdate(){
        saveTestData()
        let updatedData = "updatedDataForTest".data(using: .utf8)
        sut?.updateLoginDataInKeyChain(from: updatedData ?? Data())
        let newData = sut?.getLoginDataFromKeyChain()
        XCTAssertEqual(newData, updatedData)
    }
    
    func testDelete(){
        saveTestData()
        let loginData = sut?.getLoginDataFromKeyChain()
        XCTAssertNotNil(loginData)
        sut?.deleteLoginDataFromKeyChain()
        let newLoginData = sut?.getLoginDataFromKeyChain()
        XCTAssertNil(newLoginData)
    }
}
