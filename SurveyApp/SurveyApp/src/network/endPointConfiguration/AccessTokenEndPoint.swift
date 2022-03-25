//
//  AccessTokenEndPoint.swift
//  SurveyApp
//
//  Created by Asif on 25/3/22.
//

import Foundation
struct AccessTokenEndPoint : EndPointConfiguration{
    var requestBodyDictionary : [String : AnyHashable]
    
    var urlString : String {
        return NetworkConstants.baseUrlString
    }
    var baseURL: URL? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    var httpMethod: String{
        return NetworkConstants.httpMethodPost
    }
    
    var apiType: NetworkApiType{
        return .authenticationApi
    }
    
    var requestData: URLRequest?{
        guard let baseurl = self.baseURL else {
            return nil
        }
        var request = URLRequest(url: baseurl, timeoutInterval: 300)
        request.setValue(NetworkConstants.contentTypeFieldValue, forHTTPHeaderField: NetworkConstants.contentTypeFieldName)
        request.httpMethod = NetworkConstants.httpMethodPost
        var requestBody : Data?
        do {
            requestBody = try JSONSerialization.data(withJSONObject: self.requestBodyDictionary, options: .fragmentsAllowed)
        }
        catch let error{
            print(error.localizedDescription)
            return nil
        }
        request.httpBody = requestBody
        return request
    }
    
}
