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
    
}

// MARK:  InteractorToPresenterProtocol
extension LoginPresenter : LoginInteractorToPresenterProtocol{
    
}

extension LoginPresenter : LoginRouterToPresenterProtocol{
    
}
