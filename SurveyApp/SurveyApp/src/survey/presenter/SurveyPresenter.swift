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
        let keyChainMgr = KeyChainManager(service: KeyChainCnstants.keyChainServiceName, account: KeyChainCnstants.keyChainAccountName)
        let userDefaultmanager = UserDefaultManager()
        if let loginData = keyChainMgr.getLoginDataFromKeyChain(){
            if let tokenData = DataDecoder.decodeLoginData(from: loginData){
                loginTokenDataForInteractor = tokenData
                let loginTime = userDefaultmanager.getUserLoginTime()
                let timeDif = TimeUtil.getCurrentTimeInInt() - loginTime
                if(timeDif <= tokenData.data.attributes.expiresIn){
                    return true
                }
                return false
            }else{
                return false
            }
        }
        return false
    }
    
    private func startSurveyDataFetching(){
        if(!ReachabilityCenter.isConnectedToInternet()){
            self.view?.showErrorAlert(title: TextConstants.noInternetAlertTitle, message: TextConstants.noInternetAlertMessage, errorType: .noInternetError)
        }
        else{
            if(isAccessTokenStillValid()){
                // fetch survey data
                interector?.willFetchSurveyData(with: loginTokenDataForInteractor)
            }
            else{
                // fetch refresh token data
                interector?.requestForRefreshToken(with: loginTokenDataForInteractor)
            }
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
            //startSurveyDataFetching()
            view?.showErrorAlert(title: TextConstants.apiErrotTitle, message: TextConstants.surveyDataFailureDescription, errorType: .apiError)
        }
    }
    
    private func processRefreshToken(with data : Data?){
        let userdefaultManager = UserDefaultManager()
        guard let loginData = data else {
            userdefaultManager.setUserLoginStatus(status: false)
            //todo : show error, take user to login page
            self.view?.showErrorAlert(title: TextConstants.refreshTokenFailedTitle, message: TextConstants.refreshTokenFailedDescription, errorType: .refreshTokenError)
            return
        }
        if let loginTokenData = DataDecoder.decodeLoginData(from: loginData) {
            //print(loginTokenData)
            // data is ok, need to save
            loginTokenDataForInteractor = loginTokenData
            let keyChainManager = KeyChainManager(service: KeyChainCnstants.keyChainServiceName, account: KeyChainCnstants.keyChainAccountName)
            keyChainManager.updateLoginDataInKeyChain(from: loginData)
            userdefaultManager.setUserLoginTime(time: TimeUtil.getCurrentTimeInInt())
            startSurveyDataFetching()
         }
         else{
             //todo : show error, take user to login page
             userdefaultManager.setUserLoginStatus(status: false)
             self.view?.showErrorAlert(title: TextConstants.refreshTokenFailedTitle, message: TextConstants.refreshTokenFailedDescription, errorType: .refreshTokenError)
         }
    }
}

extension SurveyPresenter : SurveyViewToPresenterProtocol{
    func didTapOkButtonOnError(errorType: DataFetchingError) {
        switch errorType {
        case .noInternetError:
            self.startSurveyDataFetching()
        case .refreshTokenError:
            self.router?.gotoLoginPage()
        case .apiError:
            self.startSurveyDataFetching()
        }
    }
    
    func onViewDidLoadCalled() {
        view?.showSkeletonView()
        startSurveyDataFetching()
    }
}

extension SurveyPresenter : SurveyInteractorToPresenterProtocol{
    func didReceiveRefreshTokenData(with data: Data?) {
        self.processRefreshToken(with: data)
    }
    
    func backgroundImageDidAppear(with dataDict: [String : Data]) {
        self.updateView(with: dataDict)
    }
    
    func surveyDidAppear(with data: Data?) {
        self.procesSurveyData(with: data)
    }
}

extension SurveyPresenter : SurveyRouterToPresenterProtocol{
    
}
