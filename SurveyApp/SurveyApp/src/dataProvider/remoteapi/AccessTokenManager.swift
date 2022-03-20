//
//  AccessTokenManager.swift
//  SurveyApp
//
//  Created by Asif on 20/3/22.
//

import Foundation

class AccessTokenManager{
    func requestForAccessToken(with requestBodyDict : [String : AnyHashable], completion : @escaping (LoginTokenData?) -> Void){
        guard let baseUrl  = URL(string: NetworkConstants.baseUrlString) else{
            completion(nil)
            return
        }
        var request = URLRequest(url: baseUrl, timeoutInterval: Double.infinity)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        var requestBody : Data?
        do {
            requestBody = try JSONSerialization.data(withJSONObject: requestBodyDict, options: .fragmentsAllowed)
        }
        catch let error{
            print(error.localizedDescription)
            completion(nil)
            return
        }
        request.httpBody = requestBody
        let task = URLSession.shared.dataTask(with: request){data, _, error in
            guard let data = data else {
                completion(nil)
                return
            }
            let decoder = JSONDecoder()
            if let loginTokenData = try? decoder.decode(LoginTokenData.self, from: data) {
                print(loginTokenData)
                completion(loginTokenData)
            }
            else{
                completion(nil)
            }
        }
        task.resume()
    }
}
