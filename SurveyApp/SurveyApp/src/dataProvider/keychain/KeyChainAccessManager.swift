//
//  KeyChainAccessManager.swift
//  SurveyApp
//
//  Created by Asif on 21/3/22.
//

import Foundation
class KeyChainAccessManager{
    enum KeyChainError : Error{
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    static func save(service : String, account : String, dataToStore : Data) throws{
        let query : [String : AnyObject] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrService as String : service as AnyObject,
            kSecAttrAccount as String : account as AnyObject,
            kSecValueData as String : dataToStore as AnyObject
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        if(status == errSecDuplicateItem){
            throw KeyChainError.duplicateEntry
        }
        if(status != errSecSuccess){
            throw KeyChainError.unknown(status)
        }
        //print("key chain data saved")
    }
    
    static func get(service : String, account : String) -> Data?{
        let query : [String : AnyObject] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrService as String : service as AnyObject,
            kSecAttrAccount as String : account as AnyObject,
            kSecReturnData as String :  kCFBooleanTrue,
            kSecMatchLimit as String : kSecMatchLimitOne
        ]
        var result : AnyObject?
        _ = SecItemCopyMatching(query as CFDictionary, &result)
        return result as? Data
    }
    
    static func update(service : String, account : String, newData : Data){
        let query : [String : AnyObject] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : account as AnyObject,
        ]
        let newAttributes : [String : AnyObject] = [
            kSecValueData as String : newData as AnyObject
        ]
        let status = SecItemUpdate(query as CFDictionary, newAttributes as CFDictionary)
        if(status != errSecSuccess){
            print("cant update keychain")
        }
        else{
            print("key chain data updated")
        }
    }
    
    static func delete(service : String, account : String){
        let query : [String : AnyObject] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrService as String : service as AnyObject,
            kSecAttrAccount as String : account as AnyObject
        ]
        let status = SecItemDelete(query as CFDictionary)
        if(status != errSecSuccess){
            print("cant delete from keychain")
        }
        else{
            print("key chain data deleted")
        }
    }
}
