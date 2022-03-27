//
//  LoginInteractor.swift
//  SurveyApp
//
//  Created by Asif on 19/3/22.
//

import Foundation
class LoginInteractor{
    weak var presenter: LoginInteractorToPresenterProtocol?
    var networkMannger : DataFetcherProtocol?
    
    init(networkMgr : DataFetcherProtocol){
        networkMannger = networkMgr
        networkMannger?.dataFetcherDelegate = self
    }
    
    deinit{
        networkMannger = nil
    }
    
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
        networkMannger?.getAccessTokenData(requestBody: getRequestBodyForToken(userEmail, userPassword))
    }
}
extension LoginInteractor : LoginPresenterToInteractorProtocol{
    func loginProcessWillStart(userEmail: String, userPassword: String) {
        self.startLoginProcess(userEmail: userEmail, userPassword: userPassword)
    }
}

extension LoginInteractor : NetworkManagerProtocol{
    func dataDidAppear(htttpStatusCode: Int, networkApiType: NetworkApiType, receivedData: Data?) {
        switch networkApiType {
        case .authenticationApi:
            self.presenter?.didReceiveLoginData(data: receivedData, httpResponseCode: htttpStatusCode)
        default:
            print("ignor other cases for now")
        }

    }
}
