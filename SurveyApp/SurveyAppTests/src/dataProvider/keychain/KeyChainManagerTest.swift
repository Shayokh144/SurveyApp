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
    
    override func setUpWithError() throws {
        sut = KeyChainManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testSave() {
        let loginData = sut?.getLoginDataFromKeyChain()
        XCTAssertNotNil(loginData)
        sut?.saveLoginDataInKeychain(data: loginData!)
    }
    
    func testGet(){
        let loginData = sut?.getLoginDataFromKeyChain()
        XCTAssertNotNil(loginData)
    }

    func testUpdate(){
        let loginData = sut?.getLoginDataFromKeyChain()
        XCTAssertNotNil(loginData)
        sut?.updateLoginDataInKeyChain(from: Data())
        sut?.deleteLoginDataFromKeyChain()
        sut?.saveLoginDataInKeychain(data: loginData!)
    }
    
    func testDelete(){
        let loginData = sut?.getLoginDataFromKeyChain()
        XCTAssertNotNil(loginData)
        sut?.deleteLoginDataFromKeyChain()
        sut?.saveLoginDataInKeychain(data: loginData!)
        let newLoginData = sut?.getLoginDataFromKeyChain()
        XCTAssertEqual(loginData, newLoginData)
        
    }
}
