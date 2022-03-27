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
}

extension SurveyRouter : SurveyPresenterToRouterProtocol{
    func gotoLoginPage() {
        DispatchQueue.main.async {
            NavigationManager.shared.loadLoginView()
        }
    }
}
