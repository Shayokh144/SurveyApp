//
//  AuthenticationManager.swift
//  SurveyApp
//
//  Created by Asif on 19/3/22.
//

import Foundation

class AuthenticationManager{
    
    private let userDefaultManager : UserDefaultManager!
    
    init(){
        userDefaultManager = UserDefaultManager()
    }
    
    public func userDidLoggedInSuccessfully()->Bool{
        return userDefaultManager.getUserLoginStatus()
    }
    
    public func setLoginStatusToUserDefault(status : Bool){
        userDefaultManager.setUserLoginStatus(status: status)
    }
}
