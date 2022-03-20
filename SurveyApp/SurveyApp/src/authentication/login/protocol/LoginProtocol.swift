//
//  LoginProtocol.swift
//  SurveyApp
//
//  Created by Asif on 19/3/22.
//

import Foundation

//View ->Presenter
protocol LoginViewToPresenterProtocol : AnyObject {
    func didTapLoginButton(userEmail : String, userPassword : String)
}

//Presenter -> View
protocol LoginPresenterToViewProtocol : AnyObject {
    func showLoadingSpinnerView()
    func showErrorPopUp(title : String, message : String)
}

//Presenter -> Router
protocol LoginPresenterToRouterProtocol : AnyObject {
    func gotoNextView()
}

//Router -> Presenter
protocol LoginRouterToPresenterProtocol : AnyObject {
    
}

//Presenter -> Interactor
protocol LoginPresenterToInteractorProtocol : AnyObject {
    func loginProcessWillStart(userEmail : String, userPassword : String)
}

//Interactor -> Presenter
protocol LoginInteractorToPresenterProtocol : AnyObject {
    func didReceiveLoginData(data : Data?)
}
