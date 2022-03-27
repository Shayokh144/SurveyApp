//
//  SurveyRouterTest.swift
//  SurveyAppTests
//
//  Created by Asif on 27/3/22.
//

import XCTest
@testable import SurveyApp

class SurveyRouterTest: XCTestCase {

    func testSurveyAsRootViewController(){
        
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: UIConstants.storyBoardName, bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: UIConstants.surveyViewStoryBoardId) as? SurveyView
            let presenter = SurveyPresenter()
            let interactor = SurveyInteractor(networkMgr: NetworkManager(retryCount: 1))
            SurveyRouter.createSurveyModule(view: view, presenter: presenter, interactor: interactor, setAsRootView: true)
            //sleep(5)
            if(UserDefaultManager().getUserLoginStatus()){
                let status = NavigationManager.shared.getCurrentNavigationController().topViewController is SurveyView
                XCTAssertTrue(status)
            }
        }
        
    }
    func testSurveyAsViewController(){
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: UIConstants.storyBoardName, bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: UIConstants.surveyViewStoryBoardId) as? SurveyView
            let presenter = SurveyPresenter()
            let interactor = SurveyInteractor(networkMgr: NetworkManager(retryCount: 1))
            SurveyRouter.createSurveyModule(view: view, presenter: presenter, interactor: interactor, setAsRootView: false)
            if(UserDefaultManager().getUserLoginStatus()){
                let status = NavigationManager.shared.getCurrentNavigationController().topViewController is SurveyView
                XCTAssertTrue(status)
            }
        }
        
    }
}
