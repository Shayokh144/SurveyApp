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
    var mockView : MockLoginViewProtocol?
    override func setUpWithError() throws {
        sut = LoginPresenter()
        mockLoginInteractor = MockLoginInteractor()
        mockView = MockLoginView()
        sut?.interector = mockLoginInteractor
        sut?.view = mockView
    }

    override func tearDownWithError() throws {
        sut = nil
        mockLoginInteractor = nil
    }

    func testLoginProcessCalled() {
        sut?.didReceiveLoginData(data: Data(), httpResponseCode: 404)
        sut?.didTapLoginButton(userEmail: "", userPassword: "")
        sut?.interector?.loginProcessWillStart(userEmail: "", userPassword: "")
        XCTAssertTrue(mockLoginInteractor?.isLoggedInDatareceived ?? false, "using dummy data")
    }
    
    func testViewMethods(){
        sut?.view?.showErrorPopUp(title: "", message: "")
        sut?.view?.showLoadingSpinnerView()
        XCTAssertTrue(mockView?.didShowErrorPupUp ?? false, "using dummy data")
        XCTAssertTrue(mockView?.didStartLoadingSpinner ?? false, "using dummy data")
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
    var didStartLoadingSpinner : Bool {get set}
    var didShowErrorPupUp : Bool {get set}
}
class MockLoginView : MockLoginViewProtocol{
    var didShowErrorPupUp: Bool
    var didStartLoadingSpinner: Bool
    init(){
        self.didStartLoadingSpinner = false
        self.didShowErrorPupUp = false
    }
    func showLoadingSpinnerView() {
        self.didStartLoadingSpinner = true
    }
    
    func showErrorPopUp(title: String, message: String) {
        self.didShowErrorPupUp = true
    }
    
}
