//
//  NetworkProtocols.swift
//  SurveyApp
//
//  Created by Asif on 25/3/22.
//

import Foundation

protocol EndPointConfiguration{
    var baseURL: URL? { get }
    var urlString: String { get}
    var httpMethod: String { get }
    var apiType: NetworkApiType { get }
    var requestData: URLRequest? { get }
}

protocol NetworkManagerProtocol : AnyObject{
    func dataDidAppear(htttpStatusCode : Int, networkApiType: NetworkApiType,receivedData : Data?)
}

protocol DataFetcherProtocol : AnyObject{
    var dataFetcherDelegate : NetworkManagerProtocol? {get set}
    func getAccessTokenData(requestBody : [String : AnyHashable])
    func getRefreshTokenData(requestBody : [String : AnyHashable])
    func getSurveyData(pageCount : Int, tokenType : String, accessToken : String)
    func getImage(from urlString : String)
}
