//
//  SurveyEntity.swift
//  SurveyApp
//
//  Created by Asif on 21/3/22.
//

import Foundation

struct SurveyAttributes: Codable {
    enum CodingKeys: String, CodingKey {
        case title, description
        case  coverImageUrl = "cover_image_url"
    }
    var title: String
    var description: String
    var coverImageUrl: String
}
struct SurveyListData: Codable{
    var data: [SurveyAttributeList]
}
struct SurveyAttributeList : Codable {
    var attributes : SurveyAttributes
}

struct SurveyDataEntity{
    var title : String = ""
    var description : String = ""
    var bgImageData : Data = Data()
}

enum DataFetchingError{
    case noInternetError
    case refreshTokenError
    case apiError
}
