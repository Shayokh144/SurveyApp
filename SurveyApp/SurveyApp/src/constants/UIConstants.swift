//
//  UIConstants.swift
//  SurveyApp
//
//  Created by Asif on 19/3/22.
//

import Foundation
import UIKit
class UIConstants{
    public static let storyBoardName = "SurveyAppMain"
    public static let loginViewStoryBoardId = "loginViewId"
    public static let surveyViewStoryBoardId = "surveyViewController"
    public static let fontNeuzeitSLTNormal = "NeuzeitSLTStd-Book"
    public static let fontNeuzeitSLTHeavy = "NeuzeitSLTStd-BookHeavy"
    public static let loginButtonfontSize : CGFloat = 17.0
    public static let loginButtonCornerRadius : CGFloat = 6.0
    public static let emailTextFieldCornerRadius : CGFloat = 10.0
    public static let passwordTextFieldCornerRadius : CGFloat = 10.0
    public static let spacceForKeyBoard : CGFloat = -150.0
    public static let surveyCellNibName = "SurveyCollectionViewCell"
    public static let pageControlLeading : CGFloat = -48.0
    public static let pageControlSkeletonLeading : CGFloat = 8.0
    public static let screenRatio = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width) / 414.0
    public static let collectionViewMargin : CGFloat = 8.0
    public static let collectionViewHeight : CGFloat = 214.0
    public static let arrowButtonHeight : CGFloat = 56.0
    public static let arrowButtonWidth : CGFloat = 56.0
    public static let arrowButtonImageName = "Arrow"
    public static let surveyTitlefontSize : CGFloat = 28.0
    public static let surveyDescriptionfontSize : CGFloat = 17.0

    static func multiplyWithScreenRatio(constraint: NSLayoutConstraint) {
            constraint.constant = constraint.constant * UIConstants.screenRatio
    }

}

class TextConstants{
    public static let loginText = "Log in"
    public static let emailPlaceholderText = "Email"
    public static let passwordPlaceholderText = "Password"
    public static let okText = "OK"
    public static let failedLoginAlertTitle = "Login Failed!"
    public static let invalidEmailAlertMessage = "invalid email given!!\nTry again with valid email."
    public static let invalidPasswordAlertMessage = "invalid password format!!\nTry again with valid password."
    public static let noInternetAlertMessage = "Please Check your internet connection and try again"
    public static let wrongEmailOrPasswordAlertMessage = "Email or Password is wrong!"


}
