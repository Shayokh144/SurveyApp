//
//  SurveyPresenterTest.swift
//  SurveyAppTests
//
//  Created by Asif on 27/3/22.
//

import XCTest
@testable import SurveyApp

class SurveyPresenterTest: XCTestCase {
    var sut : SurveyPresenter?
    var mockSurveyInteractor : MockSurveyInteractor?
    var mockView : MockSurveyViewProtocol?
    var userLoginStatus : Bool = false
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = SurveyPresenter()
        mockSurveyInteractor = MockSurveyInteractor()
        mockView = MockSurveyView()
        sut?.interector = mockSurveyInteractor
        sut?.view = mockView
        self.userLoginStatus = AuthenticationManager().userDidLoggedInSuccessfully()
    }

    override func tearDownWithError() throws {
        sut = nil
        mockSurveyInteractor = nil
        mockView = nil
        AuthenticationManager().setLoginStatusToUserDefault(status: self.userLoginStatus)
        try super.tearDownWithError()
    }
    
    func testSurveyDataDidAppearWithUrlErrorCalled() {
        sut?.surveyDidAppear(with: 404, data: nil)
        XCTAssertTrue(mockView?.didShowErrorAlertCalled ?? false)
        XCTAssertTrue(mockView?.didHideLoadingSpinnerCalled ?? false)
    }
    
    func testDidReceiveRefreshTokenDataNil(){
        sut?.didReceiveRefreshTokenData(with: nil)
        XCTAssertTrue(mockView?.didShowErrorAlertCalled ?? false)
    }
    
    func testDidReceiveRefreshTokenDataDummy(){
        sut?.didReceiveRefreshTokenData(with: Data())
        XCTAssertTrue(mockView?.didShowErrorAlertCalled ?? false)
    }
    
    func testDidAppearBackgroundImageBlank(){
        sut?.backgroundImageDidAppear(with: [:])
        XCTAssertTrue(mockView?.didPopulateSurveyDataCalled ?? false)
        XCTAssertTrue(mockView?.didHideSkeletonViewCalled ?? false)
    }

    func testDidAppearBackgroundImageDummy(){
        sut?.currentSurveyPage = 3
        sut?.backgroundImageDidAppear(with: ["abcd":Data()])
        XCTAssertTrue(mockView?.didUpdateViewWithNewDataCalled ?? false)
    }
    
    func testScrollForNewData(){
        sut?.isDataFetchingInProgress = false
        sut?.didScrollForNewData()
        XCTAssertTrue(mockView?.didShowLoadingSpinnerCalled ?? false)
        if(sut?.loginTokenDataForInteractor == nil){
            XCTAssertTrue(mockView?.didShowErrorAlertCalled ?? false)
        }
        else{
            XCTAssertTrue(mockSurveyInteractor?.isSurveyDataRequestDone ?? false)
        }
    }
}

class  MockSurveyInteractor : MockSurveyInteractorProtocol {
    var isRefreshTokenRequestDone: Bool
    var isBackgroundImageRequestDone: Bool
    var isSurveyDataRequestDone: Bool
    
    init(){
        self.isSurveyDataRequestDone = false
        self.isRefreshTokenRequestDone = false
        self.isBackgroundImageRequestDone = false
    }
    
    func requestForRefreshToken(with tokenData: LoginTokenData) {
        self.isRefreshTokenRequestDone = true
    }
    
    func willFetchSurveyData(with surveyPageNumber: Int, tokenData: LoginTokenData) {
        self.isSurveyDataRequestDone = true
    }
    
    func willFetchBackgroundImage(with surveyData: SurveyListData) {
        self.isBackgroundImageRequestDone = true
    }
}

protocol MockSurveyInteractorProtocol : SurveyPresenterToInteractorProtocol{
    var isSurveyDataRequestDone : Bool {get set}
    var isRefreshTokenRequestDone : Bool {get set}
    var isBackgroundImageRequestDone : Bool {get set}
}

protocol MockSurveyViewProtocol : SurveyPresenterToViewProtocol{
    var didShowSkeletonViewCalled : Bool {get set}
    var didHideSkeletonViewCalled : Bool {get set}
    var didShowLoadingSpinnerCalled: Bool {get set}
    var didHideLoadingSpinnerCalled: Bool {get set}
    var didPopulateSurveyDataCalled: Bool {get set}
    var didUpdateViewWithNewDataCalled: Bool {get set}
    var didShowErrorAlertCalled: Bool {get set}
}

class MockSurveyView : MockSurveyViewProtocol{
    var didShowLoadingSpinnerCalled: Bool
    var didHideLoadingSpinnerCalled: Bool
    var didPopulateSurveyDataCalled: Bool
    var didUpdateViewWithNewDataCalled: Bool
    var didShowErrorAlertCalled: Bool
    var didShowSkeletonViewCalled: Bool
    var didHideSkeletonViewCalled: Bool

    init(){
        self.didHideSkeletonViewCalled = false
        self.didShowSkeletonViewCalled = false
        self.didShowLoadingSpinnerCalled = false
        self.didHideLoadingSpinnerCalled = false
        self.didPopulateSurveyDataCalled = false
        self.didUpdateViewWithNewDataCalled = false
        self.didShowErrorAlertCalled = false
    }
    
    func showSkeletonView() {
        self.didShowSkeletonViewCalled = true
    }
    
    func hideSkeletonView() {
        self.didHideSkeletonViewCalled = true
    }
    
    func showLoadingSpinner() {
        self.didShowLoadingSpinnerCalled = true
    }
    
    func populateSurveyData(with dataList: [SurveyDataEntity]) {
        self.didPopulateSurveyDataCalled = true
    }
    
    func updateViewWithNewData(dataList: [SurveyDataEntity]) {
        self.didUpdateViewWithNewDataCalled = true
    }
    
    func hideLoadingSpinner() {
        self.didHideLoadingSpinnerCalled = true
    }
    
    func showErrorAlert(title: String, message: String, errorType: DataFetchingError) {
        self.didShowErrorAlertCalled = true
    }
}
