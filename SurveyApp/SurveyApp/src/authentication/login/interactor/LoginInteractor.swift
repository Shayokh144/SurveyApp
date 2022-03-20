//
//  LoginInteractor.swift
//  SurveyApp
//
//  Created by Asif on 19/3/22.
//

import Foundation
class LoginInteractor{
    weak var presenter: LoginInteractorToPresenterProtocol?
    private func getRequestBodyForToken(_ userEmail : String, _ userPassword : String)->[String : AnyHashable]{
        let requestBodyDictionary : [String : AnyHashable] = [
            NetworkConstants.tokenGrantTypeFieldName : NetworkConstants.tokenGrantTypeFieldValue,
            NetworkConstants.tokenEmailFieldName : userEmail,
            NetworkConstants.tokenPasswordFieldName : userPassword,
            NetworkConstants.tokenClientIdFieldName : NetworkConstants.tokenKey,
            NetworkConstants.tokenClientSecretFieldName : NetworkConstants.tokenSecret
        ]
        return requestBodyDictionary
    }
    private func startLoginProcess(userEmail: String, userPassword: String){
        let accessTokenManager = AccessTokenManager()
        accessTokenManager.requestForAccessToken(with: getRequestBodyForToken(userEmail, userPassword)){[weak self] data in
            self?.presenter?.didReceiveLoginData(data: data)
        }
    }
}
extension LoginInteractor : LoginPresenterToInteractorProtocol{
    func loginProcessWillStart(userEmail: String, userPassword: String) {
        self.startLoginProcess(userEmail: userEmail, userPassword: userPassword)
    }
}
