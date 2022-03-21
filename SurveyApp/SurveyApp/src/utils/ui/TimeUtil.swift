//
//  TimeUtil.swift
//  SurveyApp
//
//  Created by Asif on 22/3/22.
//

import Foundation
class TimeUtil{
    class func getCurrentTimeInInt()->Int{
        let currentDate = Date()
        let timeInterval = currentDate.timeIntervalSince1970
        let dateInt = Int(timeInterval)
        return dateInt
    }
}
