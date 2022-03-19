//
//  ValidityChecker.swift
//  SurveyApp
//
//  Created by Asif on 20/3/22.
//

import Foundation
class ValidityChecker{
    
    class func isValidEmail(address : String)->Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: address)
    }
    
    class func isValidPasswordFormat(password : String) -> Bool{
        return true
    }
}
