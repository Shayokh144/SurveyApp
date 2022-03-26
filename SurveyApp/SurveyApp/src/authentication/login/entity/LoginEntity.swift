//
//  LoginEntity.swift
//  SurveyApp
//
//  Created by Asif on 19/3/22.
//

import Foundation
struct LoginTokenAttributes: Codable{
    enum CodingKeys: String, CodingKey {
        case  accessToken = "access_token"
        case  tokenType = "token_type"
        case  expiresIn = "expires_in"
        case  refreshToken = "refresh_token"
        case  createdAt = "created_at"
    }
    let date = Date()
    var accessToken: String
    var tokenType: String
    var expiresIn: Int
    var refreshToken: String
    var createdAt: Int
}
struct LoginTokenDataList : Codable{
    var attributes : LoginTokenAttributes
}
struct LoginTokenData: Codable{
    var data: LoginTokenDataList
}
