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
