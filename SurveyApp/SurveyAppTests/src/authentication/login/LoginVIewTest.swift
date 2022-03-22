//
//  LoginVIewTest.swift
//  SurveyAppTests
//
//  Created by Asif on 22/3/22.
//

import XCTest
@testable import SurveyApp

class LoginVIewTest: XCTestCase {
    
    let presenter = MockLoginPresenter()
    func makeSUT() -> LoginView {
        let storyboard = UIStoryboard(name: UIConstants.storyBoardName, bundle: nil)
        let sut = storyboard.instantiateViewController(withIdentifier: UIConstants.loginViewStoryBoardId) as! LoginView
        sut.presenter = presenter
        sut.loadViewIfNeeded()
        return sut
    }
    func testViewOperation() throws {
        let sut = makeSUT()
        sut.presenter?.didTapLoginButton(userEmail: "", userPassword: "")
        XCTAssertTrue(presenter.onLoginButtonTapped, "")
    }
    
}

class MockLoginPresenter : LoginViewToPresenterProtocol{
    
    private(set) var onLoginButtonTapped = false
    
    func didTapLoginButton(userEmail: String, userPassword: String) {
        self.onLoginButtonTapped = true
    }
    
}
