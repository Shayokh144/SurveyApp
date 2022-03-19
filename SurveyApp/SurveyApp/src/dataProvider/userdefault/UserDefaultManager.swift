//
//  UserDefaultManager.swift
//  SurveyApp
//
//  Created by Asif on 19/3/22.
//

import Foundation

class UserDefaultManager{
    
    public func getUserLoginStatus()->Bool{
        let value = UserDefaults.standard.bool(forKey: UserDefaultConstants.loggedInKey)
        return value
    }
    
    public func setUserLoginStatus(status : Bool){
        UserDefaults.standard.set(status, forKey: UserDefaultConstants.loggedInKey)
    }
}
