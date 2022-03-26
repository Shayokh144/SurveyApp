//
//  NavigationManagerTest.swift
//  SurveyAppTests
//
//  Created by Asif on 22/3/22.
//

import XCTest
@testable import SurveyApp

class NavigationManagerTest: XCTestCase {

    var sut : NavigationManager?
    override func setUpWithError() throws {
        sut = NavigationManager.shared
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testNavigationManager() {
        let navController = sut?.getCurrentNavigationController()
        XCTAssertNotNil(navController)
    }
    
    func testLoadRootViewController(){
        sut?.loadRootViewController(newViewController: UIViewController())
        XCTAssertTrue(sut?.getCurrentNavigationController().viewControllers.count ?? 0 > 0)
    }
    
    func testLoadViewController(){
        sut?.loadViewController(newViewController: UIViewController(), isFirstView: true)
        XCTAssertTrue(sut?.getCurrentNavigationController().viewControllers.count ?? 0 > 0)
        sut?.loadViewController(newViewController: UIViewController(), isFirstView: false)
        XCTAssertTrue(sut?.getCurrentNavigationController().viewControllers.count ?? 0 > 0)
    }
    
    func testSetWindowNil(){
        let window : UIWindow? = nil
        sut?.setWindow(window: window)
        XCTAssertNotNil(sut?.window)
    }
    
    func testSetWindow(){
        let window : UIWindow = UIWindow(frame:UIScreen.main.bounds)
        sut?.setWindow(window: window)
        XCTAssertNotNil(sut?.window)
    }
    
    func testLoginViewLoader(){
        sut?.loadLoginView()
        if(!UserDefaultManager().getUserLoginStatus()){
            XCTAssertTrue(sut?.navigationController?.topViewController is LoginView)
        }
        else{
            XCTAssertFalse(sut?.navigationController?.topViewController is LoginView)
        }
    }
    
    func testSurveyViewLoader(){
        sut?.loadSurveyView(isRootView: true)
        if(UserDefaultManager().getUserLoginStatus()){
            XCTAssertTrue(sut?.navigationController?.topViewController is SurveyView)
        }
        else{
            XCTAssertFalse(sut?.navigationController?.topViewController is SurveyView)
        }
        
    }
}
