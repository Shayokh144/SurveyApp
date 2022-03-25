//
//  NavigationManager.swift
//  SurveyApp
//
//  Created by Asif on 19/3/22.
//

import Foundation
import UIKit

final class NavigationManager{
    
    static let shared = NavigationManager()
    var navigationController : UINavigationController?
    var window: UIWindow?
    
    private init(){}
    
    public func setWindow(window: UIWindow?){
        if(window == nil){
            self.window = UIWindow(frame:UIScreen.main.bounds)
        }
        else{
            self.window = window
        }
    }
    
    public func getCurrentNavigationController()->UINavigationController{
        return navigationController ?? UINavigationController()
    }
    
    public func setInitialView(){
        let authenticationManager = AuthenticationManager()
        let status = authenticationManager.userDidLoggedInSuccessfully()
        if(status == true){
            //load survey view
            loadSurveyView(isRootView: false)
        }
        else{
            loadLoginView()
        }
    }
    
    public func loadViewController(newViewController : UIViewController, isFirstView : Bool){
        let navC = NavigationManager.shared.getCurrentNavigationController()
        DispatchQueue.main.async {
            if(isFirstView){
                navC.viewControllers.removeAll()
            }
            navC.pushViewController(newViewController, animated: true)
        }
    }
    
    public func loadRootViewController(newViewController : UIViewController){
        DispatchQueue.main.async {
            self.navigationController?.viewControllers.removeAll()
            self.navigationController = UINavigationController(rootViewController: newViewController)
            self.navigationController?.modalPresentationStyle = .fullScreen
            self.window?.rootViewController = self.navigationController
            self.window?.makeKeyAndVisible()
        }
    }
    
    public func loadLoginView(){
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: UIConstants.storyBoardName, bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: UIConstants.loginViewStoryBoardId) as? LoginView
            let presenter = LoginPresenter()
            let interactor = LoginInteractor(networkMgr: NetworkManager(retryCount: 1))
            LoginRouter.createLoginModule(view: view , presenter: presenter, interactor: interactor)
        }
    }
    
    public func loadSurveyView(isRootView : Bool){
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: UIConstants.storyBoardName, bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: UIConstants.surveyViewStoryBoardId) as? SurveyView
            let presenter = SurveyPresenter()
            let interactor = SurveyInteractor(networkMgr: NetworkManager(retryCount: 1))
            if(isRootView){
                SurveyRouter.createSurveyModule(view: view, presenter: presenter, interactor: interactor, setAsRootView: false)
            }
            else{
                SurveyRouter.createSurveyModule(view: view, presenter: presenter, interactor: interactor, setAsRootView: true)
                //SurveyRouter.createSurveyAsRootModule(view: view, presenter: presenter, interactor: interactor)
            }
        }
    }
}

