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
    
    private func fetchSurveyDataFromRemoteApi(with tokenData: LoginTokenData){
        let surveyDataManager = SurveyDataManager()
        surveyDataManager.requestForAccessSurveyData(with: tokenData){[weak self] data in
            self?.presenter?.surveyDidAppear(with: data)
        }
    }
}

extension SurveyInteractor : SurveyPresenterToInteractorProtocol{
    func willFetchBackgroundImage(with surveyData: SurveyListData) {
        clearOldData()
        var imageUrls = [String]()
        for data in surveyData.data{
            imageUrls.append(data.attributes.coverImageUrl)
        }
        self.startBackgroundImageFetching(with: imageUrls)
    }
    
    func willFetchSurveyData(with tokenData: LoginTokenData) {
        self.fetchSurveyDataFromRemoteApi(with: tokenData)
    }
}
