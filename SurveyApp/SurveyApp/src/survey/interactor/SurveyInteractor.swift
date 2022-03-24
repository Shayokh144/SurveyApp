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
    var downloadedImage : [String : Data] = [:]
    
    init(){
        clearOldData()
    }
    
    private func clearOldData(){
        imageDownloadCounter = 0
        downloadedImage.removeAll()
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
    private func startBackgroundImageFetching(with imageUrlList: [String]){
        if(imageDownloadCounter < imageUrlList.count){
            ImageDownloadManager.shared.downloadImage(with: imageUrlList[imageDownloadCounter]){ [weak self](imageData, cached, urlString) in
                if let imageUrl = urlString{
                    self?.downloadedImage[imageUrl] = imageData
                    self?.imageDownloadCounter += 1
                    self?.startBackgroundImageFetching(with: imageUrlList)
                }
            }

        }
        else{
            self.presenter?.backgroundImageDidAppear(with: self.downloadedImage)
        }
    }
    
    private func fetchRefreshToken(with tokenData: LoginTokenData){
        let refreshToeknValue = tokenData.data.attributes.refreshToken
        let requestBodyDict = getRefreshTokenRequestBodyDict(refreshToken: refreshToeknValue)
        let accessTokenManager = AccessTokenManager()
        accessTokenManager.requestForAccessToken(with: requestBodyDict){[weak self] data in
            self?.presenter?.didReceiveRefreshTokenData(with: data)
        }
    }
    
    private func fetchSurveyDataFromRemoteApi(with usrlString : String, tokenData: LoginTokenData){
        let surveyDataManager = SurveyDataManager()
        surveyDataManager.requestForAccessSurveyData(with: usrlString, loginTokenData:  tokenData){[weak self] data in
            self?.presenter?.surveyDidAppear(with: data)
        }
    }
}

extension SurveyInteractor : SurveyPresenterToInteractorProtocol{
    func willFetchSurveyData(with surveyUrl: String, tokenData: LoginTokenData) {
        self.fetchSurveyDataFromRemoteApi(with: surveyUrl, tokenData: tokenData)
    }
    
    func requestForRefreshToken(with tokenData: LoginTokenData) {
        self.fetchRefreshToken(with: tokenData)
    }
    
    func willFetchBackgroundImage(with surveyData: SurveyListData) {
        clearOldData()
        var imageUrls = [String]()
        for data in surveyData.data{
            imageUrls.append(data.attributes.coverImageUrl)
        }
        self.startBackgroundImageFetching(with: imageUrls)
    }
}
