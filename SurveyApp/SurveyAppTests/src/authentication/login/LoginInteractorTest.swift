//
//  LoginInteractorTest.swift
//  SurveyAppTests
//
//  Created by Asif on 22/3/22.
//

import XCTest
@testable import SurveyApp

class LoginInteractorTest: XCTestCase {

    var sut : LoginInteractor?
    var mockLoginInteractorToPresenterProtocol : MockLoginInteractorToPresenterProtocol?
    
    override func setUpWithError() throws {
        sut = LoginInteractor(networkMgr: NetworkManager(retryCount: 1))
        mockLoginInteractorToPresenterProtocol = MockLoginInteractorToPresenterProtocol()
        sut?.presenter = mockLoginInteractorToPresenterProtocol
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        mockLoginInteractorToPresenterProtocol = nil
        try super.tearDownWithError()
    }
    
    func testCanStartLoginProcess(){
        sut?.presenter?.didReceiveLoginData(data: Data(), httpResponseCode: 200)
        sut?.loginProcessWillStart(userEmail: "dev@nimblehq.co", userPassword: "12345678")
        XCTAssertNotNil(mockLoginInteractorToPresenterProtocol?.mockData)
    }
}

class MockLoginInteractorToPresenterProtocol : LoginInteractorToPresenterProtocol{
    public var mockData : Data?

    func didReceiveLoginData(data: Data?, httpResponseCode: Int) {
        mockData = data
    }
}
