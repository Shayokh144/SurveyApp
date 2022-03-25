//
//  NetworkConstants.swift
//  SurveyApp
//
//  Created by Asif on 20/3/22.
//

import Foundation

enum NetworkResponseType : Int{
    case success = 200
    case badRequest = 400
    case authenticationError = 401
    case urlNotFoundError = 404
    case othetError
}

enum NetworkApiType {
    case authenticationApi
    case refreshTokenApi
    case surveyDataApi
    case imageDownloadApi
    case other
}

class NetworkConstants{
    public static let baseUrlString = "https://survey-api.nimblehq.co/api/v1/oauth/token"
    public static let tokenGrantTypeFieldName = "grant_type"
    public static let tokenGrantTypeFieldValue = "password"
    public static let tokenEmailFieldName = "email"
    public static let tokenPasswordFieldName = "password"
    public static let tokenClientIdFieldName = "client_id"
    public static let tokenClientSecretFieldName = "client_secret"
    public static let tokenKey = "ofzl-2h5ympKa0WqqTzqlVJUiRsxmXQmt5tkgrlWnOE"
    public static let tokenSecret = "lMQb900L-mTeU-FVTCwyhjsfBwRCxwwbCitPob96cuU"
    public static let httpMethodPost = "POST"
    public static let httpMethodGet = "GET"
    public static let contentTypeFieldName = "Content-Type"
    public static let contentTypeFieldValue = "application/json"
    public static let baseUrlStringForSurvey = "https://survey-api.nimblehq.co/api/v1/surveys" //"https://survey-api.nimblehq.co/api/v1/surveys?page[number]=1&page[size]=5"
    public static let refreshTokenGrantTypeFieldValue = "refresh_token"

}
