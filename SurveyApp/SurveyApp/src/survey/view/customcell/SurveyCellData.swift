//
//  SurveyCellData.swift
//  Oauth2Project
//
//  Created by Asif on 15/3/22.
//

import Foundation
struct SurveyCellData{
    var title : String = ""
    var imageUrl : String = ""
    var description : String = ""
}
class SurveyCellDataProvider{
    private let cellData : [SurveyCellData] = {
        let surveryCell = SurveyCellData(title: "ABCD", imageUrl: "hotelimg", description: "dsfsd dfds fds fd sf dsf f s")
        var surveryCell2 = SurveyCellData(title: "EFGH", imageUrl: "reshigh", description: "jjhknvkv vkjf v fkdjnfd vvkjf v")
        return [surveryCell, surveryCell2]
    }()
    
    public func getData()->[SurveyCellData]{
        return cellData
    }
}
