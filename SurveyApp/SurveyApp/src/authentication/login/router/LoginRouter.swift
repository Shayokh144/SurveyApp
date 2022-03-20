//
//  LoginRouter.swift
//  SurveyApp
//
//  Created by Asif on 19/3/22.
//

import Foundation
import UIKit
class LoginRouter{
    
    static weak var presenter: LoginRouterToPresenterProtocol?
    
    class func createModule()-> UIViewController?{
        let storyboard = UIStoryboard(name: UIConstants.storyBoardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: UIConstants.loginViewStoryBoardId) as? LoginView
        let presenter = LoginPresenter()
        let interactor = LoginInteractor()
        viewController?.presenter = presenter
        presenter.view = viewController
        presenter.router = LoginRouter.self()
        presenter.interector = interactor
        interactor.presenter = presenter
        LoginRouter.presenter = presenter
        return viewController
    }
    
    private func loadSurveyView(){
        NavigationManager.shared.loadSurveyView(isRootView: true)
    }
}

extension LoginRouter : LoginPresenterToRouterProtocol{
    func gotoNextView() {
        self.loadSurveyView()
    }
}
