//
//  SurveyViewTest.swift
//  SurveyAppTests
//
//  Created by Asif on 22/3/22.
//

import XCTest
@testable import SurveyApp

class SurveyViewTest: XCTestCase {
    let presenter = MockSurveyPresenter()
    
    func makeSUT() -> SurveyView {
        let storyboard = UIStoryboard(name: UIConstants.storyBoardName, bundle: nil)
        let sut = storyboard.instantiateViewController(withIdentifier: UIConstants.surveyViewStoryBoardId) as! SurveyView
        sut.presenter = presenter
        sut.loadViewIfNeeded()
        return sut
    }
    func testSurveyViewOperation(){
        let sut = makeSUT()
        sut.presenter?.onViewDidLoadCalled()
        sut.presenter?.didTapOkButtonOnError(errorType: .noInternetError)
        XCTAssertTrue(presenter.onViewDidMethodLoadCalled, "")
    }
}
class MockSurveyPresenter : SurveyViewToPresenterProtocol{
    private(set) var onOKButtonTapped = false
    private(set) var onViewDidMethodLoadCalled = false
    private(set) var didScrollForNewDataCalled = false
    
    func didScrollForNewData() {
        self.didScrollForNewDataCalled = true
    }
    
    func onViewDidLoadCalled() {
        self.onViewDidMethodLoadCalled = true
    }
    
    func didTapOkButtonOnError(errorType: DataFetchingError) {
        self.onOKButtonTapped = true
    }
}
