//
//  SurveyDataManager.swift
//  SurveyApp
//
//  Created by Asif on 21/3/22.
//

import Foundation

class SurveyDataManager{
    func requestForAccessSurveyData(with surveyUrl : String, loginTokenData : LoginTokenData?, completion : @escaping (Int, Data?) -> Void){
        guard let loginData = loginTokenData else{
            completion(404, nil)
            return
        }
        let accessToken = loginData.data.attributes.accessToken
        let tokenType = loginData.data.attributes.tokenType
        guard let baseUrl  = URL(string: surveyUrl) else{
            completion(404, nil)
            return
        }
        let requestValue = tokenType + " " + accessToken
        var request = URLRequest(url: baseUrl, timeoutInterval: Double.infinity)
        request.addValue(requestValue, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else{
                completion(404, nil)
                return
            }
            guard let data = data else {
                completion(httpResponse.statusCode, nil)
                return
            }
            completion(httpResponse.statusCode, data)
        }
        task.resume()
    }
}
