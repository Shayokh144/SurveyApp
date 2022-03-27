//
//  NetworkManager.swift
//  SurveyApp
//
//  Created by Asif on 25/3/22.
//

import Foundation

class NetworkManager : DataFetcherProtocol{
    weak var dataFetcherDelegate: NetworkManagerProtocol?
    
    let retryCount : Int!
    
    //weak var delegate : NetworkManagerProtocol?
    
    init(retryCount : Int){
        self.retryCount = retryCount
    }
    
    func getAccessTokenData(requestBody : [String : AnyHashable]){
        let accessTokenEndPoint : AccessTokenEndPoint = AccessTokenEndPoint(requestBodyDictionary: requestBody)
        requestApiData(with: accessTokenEndPoint){httpStatusCode, apiType, data in
            self.dataFetcherDelegate?.dataDidAppear(htttpStatusCode: httpStatusCode, networkApiType: apiType, receivedData: data)
        }
    }
    
    func getRefreshTokenData(requestBody : [String : AnyHashable]){
        let refresfTokenEndPoint = AccessTokenEndPoint(requestBodyDictionary: requestBody)
        requestApiData(with: refresfTokenEndPoint){httpStatusCode, apiType, data in
            self.dataFetcherDelegate?.dataDidAppear(htttpStatusCode: httpStatusCode, networkApiType: .refreshTokenApi, receivedData: data)
        }
    }
    
    func getSurveyData(pageCount : Int, tokenType : String, accessToken : String){
        let surveyDataEndPoint = SurveyDataEndPoint(pageCount: pageCount, accessToken: accessToken, tokenType: tokenType)
        requestApiData(with: surveyDataEndPoint){httpStatusCode, apiType, data in
            self.dataFetcherDelegate?.dataDidAppear(htttpStatusCode: httpStatusCode, networkApiType: apiType, receivedData: data)
        }
    }
    
    func getImage(from urlString : String){
        ImageDownloadManager.shared.downloadImage(with: urlString){ [weak self](imageData, responseCode, urlString) in
            self?.dataFetcherDelegate?.dataDidAppear(htttpStatusCode: responseCode, networkApiType: .imageDownloadApi, receivedData: imageData)
        }
    }

    private func requestApiData(with endPointConfiguration : EndPointConfiguration, completion : @escaping (Int, NetworkApiType, Data?) -> Void){
        if (endPointConfiguration.baseURL == nil){
            return completion(404, endPointConfiguration.apiType ,nil)
        }
        guard let request = endPointConfiguration.requestData else {
            return completion(404, endPointConfiguration.apiType, nil)
        }
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else{
                completion(404, endPointConfiguration.apiType, nil)
                return
            }
            guard let data = data else {
                completion(httpResponse.statusCode, endPointConfiguration.apiType, nil)
                return
            }
            completion(httpResponse.statusCode, endPointConfiguration.apiType, data)
        }
        task.resume()
    }
}
