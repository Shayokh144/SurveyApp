//
//  SurveyPresenter.swift
//  SurveyApp
//
//  Created by Asif on 21/3/22.
//

import Foundation
class SurveyPresenter{
    
    weak var view : SurveyPresenterToViewProtocol?
    var interector: SurveyPresenterToInteractorProtocol?
    var router: SurveyPresenterToRouterProtocol?
    var loginTokenDataForInteractor : LoginTokenData!
    var surveyList : SurveyListData?
    
    private func isAccessTokenStillValid()->Bool{
        let keyChainMgr = KeyChainManager()
        if let loginData = keyChainMgr.getLoginDataFromKeyChain(){
            if let tokenData = DataDecoder.decodeLoginData(from: loginData){
                loginTokenDataForInteractor = tokenData
                return tokenData.data.attributes.isValid
            }else{
                return false
            }
        }
        return false
    }
    
    private func startSurveyDataFetching(){
        if(isAccessTokenStillValid()){
            // fetch survey data
            interector?.willFetchSurveyData(with: loginTokenDataForInteractor)
        }
        else{
            // fetch refresh token data
        }
    }
    
    private func startSurveyImaageFetching(surveyListData : SurveyListData){
        interector?.willFetchBackgroundImage(with: surveyListData)
    }
    
    private func updateView(with imageDataDict: [String : Data]){
        var dataListForSurveyUi : [SurveyDataEntity] = []
        if let surveyListData = self.surveyList{
            for data in surveyListData.data{
                let entity = SurveyDataEntity(title: data.attributes.title, description: data.attributes.description, bgImageData: imageDataDict[data.attributes.coverImageUrl] ?? Data())
                dataListForSurveyUi.append(entity)
            }
        }
        view?.populateSurveyData(with: dataListForSurveyUi)
        view?.hideSkeletonView()
    }
    
    private func procesSurveyData(with surveyData : Data?){
        if let surveyListData = DataDecoder.decodeSurveyData(from: surveyData ?? Data()){
            self.surveyList = surveyListData
            self.startSurveyImaageFetching(surveyListData: surveyListData)
        }
        else{
            startSurveyDataFetching()
        }
    }
}
extension SurveyPresenter : SurveyViewToPresenterProtocol{
    func onViewDidLoadCalled() {
        view?.showSkeletonView()
        startSurveyDataFetching()
    }
    
}
extension SurveyPresenter : SurveyInteractorToPresenterProtocol{
    func backgroundImageDidAppear(with dataDict: [String : Data]) {
        self.updateView(with: dataDict)
    }
    
    func surveyDidAppear(with data: Data?) {
        self.procesSurveyData(with: data)
    }
}
extension SurveyPresenter : SurveyRouterToPresenterProtocol{
    
}
