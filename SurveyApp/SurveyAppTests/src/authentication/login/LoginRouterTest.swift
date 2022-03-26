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
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: UIConstants.storyBoardName, bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: UIConstants.loginViewStoryBoardId) as? LoginView
            let presenter = LoginPresenter()
            let interactor = LoginInteractor(networkMgr: NetworkManager(retryCount: 1))
            LoginRouter.createLoginModule(view: view , presenter: presenter, interactor: interactor)
        }
        if(UserDefaultManager().getUserLoginStatus()){
            XCTAssertFalse(NavigationManager.shared.getCurrentNavigationController().topViewController is LoginView)
        }
        else{
            XCTAssertTrue(NavigationManager.shared.getCurrentNavigationController().topViewController is LoginView)
        }
    }
    
    func testLoadSurveyView(){
        LoginRouter().gotoNextView()
        if(!UserDefaultManager().getUserLoginStatus()){
            XCTAssertFalse(NavigationManager.shared.getCurrentNavigationController().topViewController is SurveyView)
        }
        else{
            XCTAssertTrue(NavigationManager.shared.getCurrentNavigationController().topViewController is SurveyView)
        }
    }
}
