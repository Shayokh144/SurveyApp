//
//  KeyChainManager.swift
//  SurveyApp
//
//  Created by Asif on 19/3/22.
//

import Foundation

class KeyChainManager{
    public func saveLoginDataInKeychain(data : Data){
        do{
            try KeyChainAccessManager.save(service:KeyChainCnstants.keyChainServiceName,
                                           account: KeyChainCnstants.keyChainAccountName,
                                           dataToStore: data)
        }
        catch let error{
            print(error)
        }
    }
    public func getLoginDataFromKeyChain()->Data?{
        return KeyChainAccessManager.get(service: KeyChainCnstants.keyChainServiceName,
                                         account: KeyChainCnstants.keyChainAccountName)
    }
    public func updateLoginDataInKeyChain(from data : Data){
        KeyChainAccessManager.update(service: KeyChainCnstants.keyChainServiceName,
                                     account: KeyChainCnstants.keyChainAccountName,
                                     newData: data)
    }
    
    public func deleteLoginDataFromKeyChain(){
        KeyChainAccessManager.delete(service: KeyChainCnstants.keyChainServiceName,
                                     account: KeyChainCnstants.keyChainAccountName)
    }
}
