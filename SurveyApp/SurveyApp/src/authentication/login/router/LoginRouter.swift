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

    class func createLoginModule(view : LoginView?, presenter : LoginPresenter, interactor : LoginInteractor){
        view?.presenter = presenter
        presenter.view = view
        presenter.router = LoginRouter.self()
        presenter.interector = interactor
        interactor.presenter = presenter
        LoginRouter.presenter = presenter
        NavigationManager.shared.loadRootViewController(newViewController: view ?? UIViewController())
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
