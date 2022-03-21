//
//  SurveyRouter.swift
//  SurveyApp
//
//  Created by Asif on 21/3/22.
//

import Foundation
import UIKit
class SurveyRouter{
    
    static weak var presenter: SurveyRouterToPresenterProtocol?
    
    class func createModule()-> UIViewController?{
        let storyboard = UIStoryboard(name: UIConstants.storyBoardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: UIConstants.surveyViewStoryBoardId) as? SurveyView
        let presenter = SurveyPresenter()
        let interactor = SurveyInteractor()
        viewController?.presenter = presenter
        presenter.view = viewController
        presenter.router = SurveyRouter.self()
        presenter.interector = interactor
        interactor.presenter = presenter
        SurveyRouter.presenter = presenter
        return viewController
    }
}

extension SurveyRouter : SurveyPresenterToRouterProtocol{
    func gotoLoginPage() {
        DispatchQueue.main.async {
            NavigationManager.shared.loadLoginView()
        }
    }
}
