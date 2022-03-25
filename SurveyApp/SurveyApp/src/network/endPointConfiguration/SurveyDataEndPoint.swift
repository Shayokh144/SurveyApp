//
//  SurveyDataEndPoint.swift
//  SurveyApp
//
//  Created by Asif on 25/3/22.
//

import Foundation

struct SurveyDataEndPoint : EndPointConfiguration{
    var pageCount : Int
    var accessToken : String
    var tokenType : String
    
    var urlString : String{
        get{
            return "https://survey-api.nimblehq.co/api/v1/surveys?page[number]=\(self.pageCount)&page[size]=5"
        }
    }
    var baseURL: URL? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    var httpMethod: String{
        return NetworkConstants.httpMethodGet
    }
    
    var apiType: NetworkApiType{
        return .surveyDataApi
    }
    
    var requestData: URLRequest?{
        guard let baseurl = self.baseURL else {
            return nil
        }
        let requestValue = self.tokenType + " " + self.accessToken
        var request = URLRequest(url: baseurl, timeoutInterval: 120)
        request.addValue(requestValue, forHTTPHeaderField: "Authorization")
        return request
    }
}
