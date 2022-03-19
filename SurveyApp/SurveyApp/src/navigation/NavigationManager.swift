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
        }
        else{
            loadLoginView()
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
}

