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
        let interactor = SurveyInteractor(networkMgr: NetworkManager(retryCount: 1))
        viewController?.presenter = presenter
        presenter.view = viewController
        presenter.router = SurveyRouter.self()
        presenter.interector = interactor
        interactor.presenter = presenter
        SurveyRouter.presenter = presenter
        return viewController
    }
    
    class func createSurveyModule(view : SurveyView?, presenter : SurveyPresenter, interactor : SurveyInteractor, setAsRootView : Bool){
        view?.presenter = presenter
        presenter.view = view
        presenter.router = SurveyRouter.self()
        presenter.interector = interactor
        interactor.presenter = presenter
        SurveyRouter.presenter = presenter
        if(setAsRootView){
            NavigationManager.shared.loadRootViewController(newViewController: view ?? UIViewController())
        }
        else{
            NavigationManager.shared.loadViewController(newViewController: view ?? UIViewController(), isFirstView: true)
        }
    }
    
    class func createSurveyAsRootModule(view : SurveyView?, presenter : SurveyPresenter, interactor : SurveyInteractor){
        view?.presenter = presenter
        presenter.view = view
        presenter.router = SurveyRouter.self()
        presenter.interector = interactor
        interactor.presenter = presenter
        SurveyRouter.presenter = presenter
        NavigationManager.shared.loadRootViewController(newViewController: view ?? UIViewController())
    }
}

extension SurveyRouter : SurveyPresenterToRouterProtocol{
    func gotoLoginPage() {
        DispatchQueue.main.async {
            NavigationManager.shared.loadLoginView()
        }
    }
}
