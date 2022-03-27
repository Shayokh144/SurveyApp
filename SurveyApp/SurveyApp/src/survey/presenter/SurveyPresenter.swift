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
    var currentSurveyPage : Int = 0
    var isDataFetchingInProgress = false
    init(){
        self.isDataFetchingInProgress = false
        self.currentSurveyPage = 1
    }
    
    private func getLoginTokenDataFromKeyChain()->LoginTokenData?{
        if(loginTokenDataForInteractor != nil){
            return loginTokenDataForInteractor
        }
        let keyChainMgr = KeyChainManager(service: KeyChainCnstants.keyChainServiceName, account: KeyChainCnstants.keyChainAccountName)
        if let loginData = keyChainMgr.getLoginDataFromKeyChain(){
            if let tokenData = DataDecoder.decodeLoginData(from: loginData){
                loginTokenDataForInteractor = tokenData
            }
        }
        return loginTokenDataForInteractor
    }
    
    private func getSurveyUrl()->String{
        return "https://survey-api.nimblehq.co/api/v1/surveys?page[number]=\(self.currentSurveyPage)&page[size]=5"
    }
    
    private func startSurveyDataFetching(){
        if(!ReachabilityCenter.isConnectedToInternet()){
            self.isDataFetchingInProgress = false
            self.view?.showErrorAlert(title: TextConstants.noInternetAlertTitle, message: TextConstants.noInternetAlertMessage, errorType: .noInternetError)
        }
        else{
            if let tokenData = getLoginTokenDataFromKeyChain(){
                interector?.willFetchSurveyData(with: self.currentSurveyPage, tokenData: tokenData)
            }
            else{
                self.view?.showErrorAlert(title: TextConstants.refreshTokenFailedTitle, message: TextConstants.refreshTokenFailedDescription, errorType: .refreshTokenError)
            }
        }
    }
    
    private func startSurveyImaageFetching(surveyListData : SurveyListData){
        interector?.willFetchBackgroundImage(with: surveyListData)
    }
    
    private func updateView(with imageDataDict: [String : Data]){
        self.isDataFetchingInProgress = false
        var dataListForSurveyUi : [SurveyDataEntity] = []
        if let surveyListData = self.surveyList{
            for data in surveyListData.data{
                let entity = SurveyDataEntity(title: data.attributes.title, description: data.attributes.description, bgImageData: imageDataDict[data.attributes.coverImageUrl] ?? Data())
                dataListForSurveyUi.append(entity)
            }
        }
        if(self.currentSurveyPage > 2){
            view?.updateViewWithNewData(dataList: dataListForSurveyUi)
        }
        else{
            view?.populateSurveyData(with: dataListForSurveyUi)
            view?.hideSkeletonView()
        }
        
    }
    
    private func procesSurveyData(with surveyData : Data?){
        if let surveyListData = DataDecoder.decodeSurveyData(from: surveyData ?? Data()){
            self.surveyList = surveyListData
            self.currentSurveyPage += 1
            self.startSurveyImaageFetching(surveyListData: surveyListData)
        }
        else{
            self.isDataFetchingInProgress = false
            //startSurveyDataFetching()
            view?.showErrorAlert(title: TextConstants.apiErrotTitle, message: TextConstants.surveyDataFailureDescription, errorType: .apiError)
        }
    }
    
    private func processRefreshToken(with data : Data?){
        let userdefaultManager = UserDefaultManager()
        guard let loginData = data else {
            userdefaultManager.setUserLoginStatus(status: false)
            //todo : show error, take user to login page
            self.isDataFetchingInProgress = false
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
            self.isDataFetchingInProgress = false
            userdefaultManager.setUserLoginStatus(status: false)
            self.view?.showErrorAlert(title: TextConstants.refreshTokenFailedTitle, message: TextConstants.refreshTokenFailedDescription, errorType: .refreshTokenError)
        }
    }
}

extension SurveyPresenter : SurveyViewToPresenterProtocol{
    func didScrollForNewData() {
        if(self.isDataFetchingInProgress ==  false){
            self.view?.showLoadingSpinner()
            self.startSurveyDataFetching()
            self.isDataFetchingInProgress = true
        }
    }
    
    func didTapOkButtonOnError(errorType: DataFetchingError) {
        self.isDataFetchingInProgress = false
        switch errorType {
        case .noInternetError:
            self.startSurveyDataFetching()
        case .refreshTokenError:
            self.router?.gotoLoginPage()
        case .apiError:
            self.startSurveyDataFetching()
        case .noDataFound:
            print("no more data found")
        }
    }
    
    func onViewDidLoadCalled() {
        view?.showSkeletonView()
        startSurveyDataFetching()
    }
}

extension SurveyPresenter : SurveyInteractorToPresenterProtocol{
    func surveyDidAppear(with httpStatusCode: Int, data: Data?) {
        if(NetworkResponseType.success.rawValue == httpStatusCode){
            self.procesSurveyData(with: data)
        }
        else if (NetworkResponseType.authenticationError.rawValue == httpStatusCode){
            if let loginTokenData = self.getLoginTokenDataFromKeyChain(){
                self.interector?.requestForRefreshToken(with: loginTokenData)
            }
            else{
                self.view?.showErrorAlert(title: TextConstants.refreshTokenFailedTitle, message: TextConstants.refreshTokenFailedDescription, errorType: .refreshTokenError)
            }
        }
        else if(NetworkResponseType.urlNotFoundError.rawValue == httpStatusCode){
            self.isDataFetchingInProgress = false
            self.view?.hideLoadingSpinner()
            self.view?.showErrorAlert(title: "Data Not Found", message: "no more data to load", errorType: .noDataFound)
        }
    }
    
    func didReceiveRefreshTokenData(with data: Data?) {
        self.processRefreshToken(with: data)
    }
    
    func backgroundImageDidAppear(with dataDict: [String : Data]) {
        self.updateView(with: dataDict)
    }
    
}

extension SurveyPresenter : SurveyRouterToPresenterProtocol{
    
}
