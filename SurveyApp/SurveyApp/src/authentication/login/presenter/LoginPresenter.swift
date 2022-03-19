//
//  LoginPresenter.swift
//  SurveyApp
//
//  Created by Asif on 19/3/22.
//

import Foundation
class LoginPresenter{
    weak var view : LoginPresenterToViewProtocol?
    var interector: LoginPresenterToInteractorProtocol?
    var router: LoginPresenterToRouterProtocol?
}

extension LoginPresenter : LoginViewToPresenterProtocol{
    func didTapLoginButton(userEmail: String, userPassword: String) {
        if(!ValidityChecker.isValidEmail(address: userEmail)){
            view?.showErrorPopUp(title: TextConstants.failedLoginAlertTitle, message: TextConstants.invalidEmailAlertMessage)
        }
        if(!ValidityChecker.isValidPasswordFormat(password: userPassword)){
            view?.showErrorPopUp(title: TextConstants.failedLoginAlertTitle, message: TextConstants.invalidPasswordAlertMessage)
        }
        if(!ReachabilityCenter.isConnectedToInternet()){
            view?.showErrorPopUp(title: TextConstants.failedLoginAlertTitle, message: TextConstants.noInternetAlertMessage)
        }
        interector?.loginProcessWillStart(userEmail: userEmail, userPassword: userPassword)
    }
}

// MARK:  InteractorToPresenterProtocol
extension LoginPresenter : LoginInteractorToPresenterProtocol{
    
}

extension LoginPresenter : LoginRouterToPresenterProtocol{
    
}
