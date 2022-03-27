//
//  SurveyInteractorTest.swift
//  SurveyAppTests
//
//  Created by Asif on 27/3/22.
//

import XCTest
@testable import SurveyApp

class SurveyInteractorTest: XCTestCase, MockNetworkManagerProtocolForInteractor {
    var sut : SurveyInteractor?
    var mockPresenter : MockSurveyPresenterForInteractor?
    var mockNetworkManager : DataFetcherProtocol?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        print("setup with error called MockNetworkManager")
        mockNetworkManager = MockNetworkManager()
        sut = SurveyInteractor(networkMgr: MockNetworkManager())
        mockPresenter = MockSurveyPresenterForInteractor()
        sut?.presenter = mockPresenter
        sut?.networkMannger?.dataFetcherDelegate = self
    }
    
    func dataDidAppear(htttpStatusCode: Int, networkApiType: NetworkApiType, receivedData: Data?) {
        switch networkApiType {
        case .refreshTokenApi:
            //print("refresh data arrived")
            mockPresenter?.didReceiveRefreshTokenData(with: receivedData)
        case .surveyDataApi:
            //print("survey data arrived")
            mockPresenter?.surveyDidAppear(with: htttpStatusCode, data : receivedData)
        case.imageDownloadApi:
            //print("image data arrived")
            mockPresenter?.backgroundImageDidAppear(with: [:])
        default:
            print("ignor other cases for now")
        }
    }
    
    func testGetRefreshTokenData() {
        sut?.networkMannger?.getRefreshTokenData(requestBody: [:])
        XCTAssertTrue(mockPresenter?.didReceiveRefreshTokenDataCalled ?? false)
    }
    func testSurveyDidAppear() {
        sut?.networkMannger?.getSurveyData(pageCount: 1, tokenType: "", accessToken: "")
        XCTAssertTrue(mockPresenter?.surveyDidAppearCalled ?? false)
    }
    
    func testBackgroundImageDidAppear() {
        sut?.networkMannger?.getImage(from: "")
        XCTAssertTrue(mockPresenter?.backgroundImageDidAppearCalled ?? false)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockPresenter = nil
        mockNetworkManager = nil
        try super.tearDownWithError()
    }
}

protocol MockSurveyPresenterProtocol : SurveyInteractorToPresenterProtocol{
    var didReceiveRefreshTokenDataCalled : Bool {get set}
    var surveyDidAppearCalled : Bool {get set}
    var backgroundImageDidAppearCalled : Bool {get set}
}

class MockSurveyPresenterForInteractor : MockSurveyPresenterProtocol{
    
    var didReceiveRefreshTokenDataCalled: Bool
    var surveyDidAppearCalled: Bool
    var backgroundImageDidAppearCalled: Bool
    
    init(){
        self.didReceiveRefreshTokenDataCalled = false
        self.surveyDidAppearCalled = false
        self.backgroundImageDidAppearCalled = false
    }
    
    func didReceiveRefreshTokenData(with data: Data?) {
        self.didReceiveRefreshTokenDataCalled = true
    }
    
    func surveyDidAppear(with httpStatusCode: Int, data: Data?) {
        self.surveyDidAppearCalled = true
    }
    
    func backgroundImageDidAppear(with dataDict: [String : Data]) {
        self.backgroundImageDidAppearCalled = true
    }
}

protocol MockNetworkManagerProtocolForInteractor : NetworkManagerProtocol{
    
}

class MockNetworkManager : DataFetcherProtocol{
    
    weak var dataFetcherDelegate: NetworkManagerProtocol?
    
    func getImage(from urlString: String) {
        dataFetcherDelegate?.dataDidAppear(htttpStatusCode: 200, networkApiType: .imageDownloadApi, receivedData: Data())
    }
    
    

    func getAccessTokenData(requestBody: [String : AnyHashable]) {
        dataFetcherDelegate?.dataDidAppear(htttpStatusCode: 200, networkApiType: .authenticationApi, receivedData: Data())
    }
    
    func getRefreshTokenData(requestBody: [String : AnyHashable]) {
        dataFetcherDelegate?.dataDidAppear(htttpStatusCode: 200, networkApiType: .refreshTokenApi, receivedData: Data())
    }
    
    func getSurveyData(pageCount: Int, tokenType: String, accessToken: String) {
        dataFetcherDelegate?.dataDidAppear(htttpStatusCode: 200, networkApiType: .surveyDataApi, receivedData: Data())
    }
}
