//
//  KeyChainManager.swift
//  SurveyApp
//
//  Created by Asif on 19/3/22.
//

import Foundation

class KeyChainManager{
    private let serviceName : String!
    private let accountName : String!
    
    init(service : String, account : String){
        self.serviceName = service
        self.accountName = account
    }
    
    public func saveLoginDataInKeychain(data : Data){
        do{
            try KeyChainAccessManager.save(service: self.serviceName,
                                           account: self.accountName,
                                           dataToStore: data)
        }
        catch let error{
            print(error)
        }
    }
    public func getLoginDataFromKeyChain()->Data?{
        return KeyChainAccessManager.get(service: self.serviceName,
                                         account: self.accountName)
    }
    public func updateLoginDataInKeyChain(from data : Data){
        KeyChainAccessManager.update(service: self.serviceName,
                                     account: self.accountName,
                                     newData: data)
    }
    
    public func deleteLoginDataFromKeyChain(){
        KeyChainAccessManager.delete(service: self.serviceName,
                                     account: self.accountName)
    }
}
