//
//  SurveyInteractor.swift
//  SurveyApp
//
//  Created by Asif on 21/3/22.
//

import Foundation
class SurveyInteractor{
    
    weak var presenter: SurveyInteractorToPresenterProtocol?
    var imageDownloadCounter = 0
    var imageUrlListForDownload : [String] = []
    var downloadedImage : [String : Data] = [:]
    var networkMannger : DataFetcherProtocol?
    
    init(networkMgr : DataFetcherProtocol){
        clearOldData()
        networkMannger = networkMgr
        networkMannger?.dataFetcherDelegate = self
    }
    
    deinit{
        networkMannger = nil
    }
    
    private func clearOldData(){
        imageDownloadCounter = 0
        downloadedImage.removeAll()
        imageUrlListForDownload.removeAll()
    }
    
    private func getRefreshTokenRequestBodyDict(refreshToken : String) -> [String : AnyHashable]{
        let requestBodyDictionary : [String : AnyHashable] = [
            NetworkConstants.tokenGrantTypeFieldName : NetworkConstants.refreshTokenGrantTypeFieldValue,
            NetworkConstants.refreshTokenGrantTypeFieldValue : refreshToken,
            NetworkConstants.tokenClientIdFieldName : NetworkConstants.tokenKey,
            NetworkConstants.tokenClientSecretFieldName : NetworkConstants.tokenSecret
        ]
        return requestBodyDictionary
    }
    
    private func startBackgroundImageFetching(with imageUrl : String){
        networkMannger?.getImage(from: imageUrl)
    }
    
    private func didReceiveImageData(imageData : Data){
        self.downloadedImage[self.imageUrlListForDownload[self.imageDownloadCounter]] = imageData
        self.imageDownloadCounter += 1
        if(imageDownloadCounter < imageUrlListForDownload.count){
            startBackgroundImageFetching(with: imageUrlListForDownload[imageDownloadCounter])
        }
        else{
            self.presenter?.backgroundImageDidAppear(with: self.downloadedImage)
        }
    }
    
    private func fetchRefreshToken(with tokenData: LoginTokenData){
        let refreshToeknValue = tokenData.data.attributes.refreshToken
        let requestBodyDict = getRefreshTokenRequestBodyDict(refreshToken: refreshToeknValue)
        networkMannger?.getRefreshTokenData(requestBody: requestBodyDict)
    }
    
    private func fetchSurveyDataFromRemoteApi(with surveyPageNumber : Int, tokenData: LoginTokenData){
        networkMannger?.getSurveyData(pageCount: surveyPageNumber, tokenType: tokenData.data.attributes.tokenType, accessToken: tokenData.data.attributes.accessToken)
    }
}

extension SurveyInteractor : SurveyPresenterToInteractorProtocol{
    func willFetchSurveyData(with surveyPageNumber: Int, tokenData: LoginTokenData) {
        self.fetchSurveyDataFromRemoteApi(with: surveyPageNumber, tokenData: tokenData)
    }
    
    func requestForRefreshToken(with tokenData: LoginTokenData) {
        self.fetchRefreshToken(with: tokenData)
    }
    
    func willFetchBackgroundImage(with surveyData: SurveyListData) {
        clearOldData()
        for data in surveyData.data{
            imageUrlListForDownload.append(data.attributes.coverImageUrl)
        }
        self.startBackgroundImageFetching(with: imageUrlListForDownload[0])
    }
}

extension SurveyInteractor : NetworkManagerProtocol{
    func dataDidAppear(htttpStatusCode: Int, networkApiType: NetworkApiType, receivedData: Data?) {
        switch networkApiType {
        case .refreshTokenApi:
            //print("refresh data arrived")
            self.presenter?.didReceiveRefreshTokenData(with: receivedData)
        case .surveyDataApi:
            //print("survey data arrived")
            self.presenter?.surveyDidAppear(with: htttpStatusCode, data : receivedData)
        case.imageDownloadApi:
            //print("image data arrived")
            self.didReceiveImageData(imageData: receivedData ?? Data())
        default:
            print("ignor other cases for now")
        }

    }
}
