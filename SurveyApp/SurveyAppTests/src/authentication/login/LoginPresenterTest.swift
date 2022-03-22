//
//  LoginPresenterTest.swift
//  SurveyAppTests
//
//  Created by Asif on 22/3/22.
//

import XCTest
@testable import SurveyApp

class LoginPresenterTest: XCTestCase {
    var sut : LoginPresenter?
    var mockLoginInteractor : MockLoginInteractor?
    var mockView : Int?
    override func setUpWithError() throws {
        sut = LoginPresenter()
        mockLoginInteractor = MockLoginInteractor()
        sut?.interector = mockLoginInteractor
    }

    override func tearDownWithError() throws {
        sut = nil
        mockLoginInteractor = nil
    }

    func testLoginProcessCalled() {
        sut?.didReceiveLoginData(data: Data())
        sut?.didTapLoginButton(userEmail: "", userPassword: "")
        sut?.interector?.loginProcessWillStart(userEmail: "", userPassword: "")
        XCTAssertTrue(mockLoginInteractor?.isLoggedInDatareceived ?? false, "using dummy data")
    }

}
class  MockLoginInteractor : MockLoginInteractorProtocol {
    var isLoggedInDatareceived: Bool
    init(){
        self.isLoggedInDatareceived = false
    }
    func loginProcessWillStart(userEmail: String, userPassword: String) {
        self.isLoggedInDatareceived = true
    }
}

protocol MockLoginInteractorProtocol : LoginPresenterToInteractorProtocol{
    var isLoggedInDatareceived : Bool {get set}
}
protocol MockLoginViewProtocol : LoginPresenterToViewProtocol{
    var didStartViewUpdating : Bool {get set}
}
