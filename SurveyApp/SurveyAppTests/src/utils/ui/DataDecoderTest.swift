//
//  DataDecoderTest.swift
//  SurveyAppTests
//
//  Created by Asif on 22/3/22.
//

import XCTest
@testable import SurveyApp

class DataDecoderTest: XCTestCase {
    var dataString = ""
    let validLoginDataString = "{\"data\" : { \"attributes\" : {\"access_token\" : \"zffHZDJ7PymYk7aWVgHkCLsWdu9AiulSo40UoW29Kd0\",\"created_at\" : 1647281997,\"expires_in\" : 7200, \"refresh_token\" : \"ryrdij4w46gavEGjwffQt7Hkns2AMXabm5RlCdj3aqY\",\"token_type\" : \"Bearer\"},\"id\" : 4729, \"type\" : \"token\",},}"
    func testValidLoginDataDecoder(){
        let data = validLoginDataString.data(using: .utf8)
        XCTAssertNotNil(DataDecoder.decodeLoginData(from: data ?? Data()))
    }
    
    func testInvalidLoginDataDecoder(){
        let dataString = "habcd"
        let data = dataString.data(using: .utf8)
        XCTAssertNil(DataDecoder.decodeLoginData(from: data ?? Data()))
    }
    
    func testLoginDataEncoder(){
        let data = validLoginDataString.data(using: .utf8)
        let dataStruct = DataDecoder.decodeLoginData(from: data ?? Data())
        if(dataStruct != nil){
            XCTAssertNotNil(DataDecoder.encodeLoginData(from: dataStruct!))
        }

    }

}
