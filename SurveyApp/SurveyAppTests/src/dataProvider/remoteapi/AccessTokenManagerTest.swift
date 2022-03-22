//
//  AccessTokenManagerTest.swift
//  SurveyAppTests
//
//  Created by Asif on 22/3/22.
//

import XCTest
@testable import SurveyApp

class AccessTokenManagerTest: XCTestCase {
    var sut : AccessTokenManager?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = AccessTokenManager()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func testAccessTokenManagerWithInvalidRequest() {
        var tokenData : Data?
        let expectation = self.expectation(description: "AccessTokenManagerWithInvalidRequest")
        let requestBodyDictionary : [String : AnyHashable] = [
            NetworkConstants.tokenGrantTypeFieldName : NetworkConstants.tokenGrantTypeFieldValue,
            NetworkConstants.tokenEmailFieldName : "email",
            NetworkConstants.tokenPasswordFieldName : "passsword",
            NetworkConstants.tokenClientIdFieldName : "NetworkConstants.tokenKey",
            NetworkConstants.tokenClientSecretFieldName : "NetworkConstants.tokenSecret"
        ]
        sut?.requestForAccessToken(with: requestBodyDictionary){ data in
            tokenData = data
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertNotNil(tokenData)
        let loginData = DataDecoder.decodeLoginData(from: tokenData ?? Data())
        XCTAssertNil(loginData)
        
    }
    
    func testAccessTokenManagerWithValidRequest() {
        var tokenData : Data?
        let expectation = self.expectation(description: "AccessTokenManagerWithValidRequest")
        let requestBodyDictionary : [String : AnyHashable] = [
            NetworkConstants.tokenGrantTypeFieldName : NetworkConstants.tokenGrantTypeFieldValue,
            NetworkConstants.tokenEmailFieldName : "dev@nimblehq.co",
            NetworkConstants.tokenPasswordFieldName : "12345678",
            NetworkConstants.tokenClientIdFieldName : NetworkConstants.tokenKey,
            NetworkConstants.tokenClientSecretFieldName : NetworkConstants.tokenSecret
        ]
        sut?.requestForAccessToken(with: requestBodyDictionary){ data in
            tokenData = data
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertNotNil(tokenData)
        let loginData = DataDecoder.decodeLoginData(from: tokenData ?? Data())
        XCTAssertNotNil(loginData)
    }
    
    
}
