//
//  SurveyProtocol.swift
//  SurveyApp
//
//  Created by Asif on 21/3/22.
//

import Foundation

//View ->Presenter
protocol SurveyViewToPresenterProtocol : AnyObject {
    func onViewDidLoadCalled()
}

//Presenter -> View
protocol SurveyPresenterToViewProtocol : AnyObject {
    func showSkeletonView()
    func hideSkeletonView()
    func populateSurveyData(with dataList : [SurveyDataEntity])
}

//Presenter -> Router
protocol SurveyPresenterToRouterProtocol : AnyObject {
}

//Router -> Presenter
protocol SurveyRouterToPresenterProtocol : AnyObject {
    
}

//Presenter -> Interactor
protocol SurveyPresenterToInteractorProtocol : AnyObject {
    func willFetchSurveyData(with tokenData : LoginTokenData)
    func willFetchBackgroundImage(with surveyData : SurveyListData)
}

//Interactor -> Presenter
protocol SurveyInteractorToPresenterProtocol : AnyObject {
    func surveyDidAppear(with data : Data?)
    func backgroundImageDidAppear(with dataDict : [String : Data])
}
