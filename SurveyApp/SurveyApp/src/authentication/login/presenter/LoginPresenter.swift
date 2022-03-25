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
    
    private func gotoNextView(){
        router?.gotoNextView()
    }
    
    private func processUserLoginRequest(_ userEmail : String, _ userPassword: String){
        view?.showLoadingSpinnerView()
        if(!ValidityChecker.isValidEmail(address: userEmail)){
            view?.showErrorPopUp(title: TextConstants.failedLoginAlertTitle, message: TextConstants.invalidEmailAlertMessage)
        }
        else if(!ValidityChecker.isValidPasswordFormat(password: userPassword)){
            view?.showErrorPopUp(title: TextConstants.failedLoginAlertTitle, message: TextConstants.invalidPasswordAlertMessage)
        }
        else if(!ReachabilityCenter.isConnectedToInternet()){
            view?.showErrorPopUp(title: TextConstants.failedLoginAlertTitle, message: TextConstants.noInternetAlertMessage)
        }
        else{
            interector?.loginProcessWillStart(userEmail: userEmail, userPassword: userPassword)
        }
    }
}

extension LoginPresenter : LoginViewToPresenterProtocol{
    func didTapLoginButton(userEmail: String, userPassword: String) {
        self.processUserLoginRequest(userEmail, userPassword)
    }
}

// MARK:  InteractorToPresenterProtocol
extension LoginPresenter : LoginInteractorToPresenterProtocol{
    func didReceiveLoginData(data: Data?, httpResponseCode: Int) {
        if (httpResponseCode == NetworkResponseType.authenticationError.rawValue || httpResponseCode == NetworkResponseType.badRequest.rawValue){
            self.view?.showErrorPopUp(title: TextConstants.failedLoginAlertTitle, message: TextConstants.wrongEmailOrPasswordAlertMessage)
        }
        else if(httpResponseCode != NetworkResponseType.success.rawValue){
            self.view?.showErrorPopUp(title: TextConstants.failedLoginAlertTitle, message: TextConstants.tryAgain)
        }
        else{
            guard let loginData = data else {
                self.view?.showErrorPopUp(title: TextConstants.failedLoginAlertTitle, message: TextConstants.wrongEmailOrPasswordAlertMessage)
                return
            }
            //print(loginData)
            if DataDecoder.decodeLoginData(from: loginData) != nil {
                //print(loginTokenData)
                // data is ok, need to save
                let keyChainManager = KeyChainManager(service: KeyChainCnstants.keyChainServiceName, account: KeyChainCnstants.keyChainAccountName)
                keyChainManager.saveLoginDataInKeychain(data: loginData)
                let userdefaultManager = UserDefaultManager()
                userdefaultManager.setUserLoginStatus(status: true)
                userdefaultManager.setUserLoginTime(time: TimeUtil.getCurrentTimeInInt())
                self.gotoNextView()
             }
             else{
                 self.view?.showErrorPopUp(title: TextConstants.failedLoginAlertTitle, message: TextConstants.wrongEmailOrPasswordAlertMessage)
             }
        }
    }
}

extension LoginPresenter : LoginRouterToPresenterProtocol{
    
}
