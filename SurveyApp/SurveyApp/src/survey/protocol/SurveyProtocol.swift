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
    func didTapOkButtonOnError(errorType : DataFetchingError)
}

//Presenter -> View
protocol SurveyPresenterToViewProtocol : AnyObject {
    func showSkeletonView()
    func hideSkeletonView()
    func populateSurveyData(with dataList : [SurveyDataEntity])
    func showErrorAlert(title : String, message : String, errorType : DataFetchingError)
}

//Presenter -> Router
protocol SurveyPresenterToRouterProtocol : AnyObject {
    func gotoLoginPage()
}

//Router -> Presenter
protocol SurveyRouterToPresenterProtocol : AnyObject {
    
}

//Presenter -> Interactor
protocol SurveyPresenterToInteractorProtocol : AnyObject {
    func requestForRefreshToken(with tokenData : LoginTokenData)
    func willFetchSurveyData(with tokenData : LoginTokenData)
    func willFetchBackgroundImage(with surveyData : SurveyListData)
}

//Interactor -> Presenter
protocol SurveyInteractorToPresenterProtocol : AnyObject {
    func didReceiveRefreshTokenData(with data : Data?)
    func surveyDidAppear(with data : Data?)
    func backgroundImageDidAppear(with dataDict : [String : Data])
}
