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
    
    public func loadViewController(newViewController : UIViewController){
        let navC = NavigationManager.shared.getCurrentNavigationController()
        DispatchQueue.main.async {
            navC.pushViewController(newViewController, animated: true)
        }
    }
    
    public func loadLoginView(){
        /*let storyboard = UIStoryboard(name: UIConstants.storyBoardName, bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: UIConstants.loginViewStoryBoardId)*/
        let loginVC = LoginRouter.createModule()
        self.navigationController = UINavigationController(rootViewController: loginVC ?? UIViewController())
        self.navigationController?.modalPresentationStyle = .fullScreen
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
    }
    
    public func loadSurveyView(isRootView : Bool){
        if(isRootView){
            let navC = NavigationManager.shared.getCurrentNavigationController()
            DispatchQueue.main.async {
                navC.viewControllers.removeAll()
                let surveyVc = SurveyRouter.createModule()
                navC.pushViewController(surveyVc ?? UIViewController(), animated: true)
                //print(navC.viewControllers.count)
            }
        }
        else{
            let surveyVc = SurveyRouter.createModule()
            self.navigationController = UINavigationController(rootViewController: surveyVc ?? UIViewController())
            self.navigationController?.modalPresentationStyle = .fullScreen
            self.window?.rootViewController = self.navigationController
            self.window?.makeKeyAndVisible()
        }
    }
}

