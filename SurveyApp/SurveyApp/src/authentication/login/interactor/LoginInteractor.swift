//
//  LoginInteractor.swift
//  SurveyApp
//
//  Created by Asif on 19/3/22.
//

import Foundation
class LoginInteractor{
    weak var presenter: LoginInteractorToPresenterProtocol?
}
extension LoginInteractor : LoginPresenterToInteractorProtocol{
    func loginProcessWillStart(userEmail: String, userPassword: String) {
        
    }
}
