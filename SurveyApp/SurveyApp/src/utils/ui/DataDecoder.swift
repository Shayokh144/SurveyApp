//
//  DataDecoder.swift
//  SurveyApp
//
//  Created by Asif on 20/3/22.
//

import Foundation
class DataDecoder{
    static func decodeLoginData(from data : Data)->LoginTokenData?{
        let decoder = JSONDecoder()
        if let loginTokenData = try? decoder.decode(LoginTokenData.self, from: data) {
            //print(loginTokenData)
            return loginTokenData
        }
        return nil
    }
    static func encodeLoginData(from loginTokenData : LoginTokenData)-> Data?{
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(loginTokenData) {
            return encodedData
        }
        return nil
    }
}
