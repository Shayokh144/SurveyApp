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
    public static let surveyDetailsViewStoryBoardId = "surveyDetailsViewController"
    public static let fontNeuzeitSLTNormal = "NeuzeitSLTStd-Book"
    public static let fontNeuzeitSLTHeavy = "NeuzeitSLTStd-BookHeavy"
    public static let loginButtonfontSize : CGFloat = 17.0
    public static let loginButtonCornerRadius : CGFloat = 6.0
    public static let emailTextFieldCornerRadius : CGFloat = 10.0
    public static let passwordTextFieldCornerRadius : CGFloat = 10.0
    public static let spacceForKeyBoard : CGFloat = -20.0
    public static let surveyCellNibName = "SurveyCollectionViewCell"
    public static let pageControlLeading : CGFloat = -40.0
    public static let pageControlSkeletonLeading : CGFloat = 8.0
    public static let screenRatio = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width) / 414.0
    public static let collectionViewMargin : CGFloat = 8.0
    public static let collectionViewHeight : CGFloat = 170.0
    public static let arrowButtonHeight : CGFloat = 56.0
    public static let arrowButtonWidth : CGFloat = 56.0
    public static let arrowButtonImageName = "Arrow"
    public static let surveyTitlefontSize : CGFloat = 28.0
    public static let surveyDescriptionfontSize : CGFloat = 17.0
    public static let skeletonCornerRadius : Int = 8
    public static let skeletonBaseGradiantColor : UIColor = UIColor(red: 60, green: 60, blue: 60, alpha: 0.2)
    public static let skeletonSecondaryGradiantColor : UIColor = UIColor(red: 60, green: 60, blue: 60, alpha: 0.4)
    public static let loginButtonAccesibilityIdentifier = "loginButtonAccesibilityIdentifier"
    public static let emailTextFieldAccesibilityIdentifier = "emailTextFieldAccesibilityIdentifier"
    public static let passwordTextFieldAccesibilityIdentifier = "passwordTextFieldAccesibilityIdentifier"
    public static let loginAlertAccesibilityIdentifier = "loginAlertId"
    public static let surveyCellTitleAccesibilityIdentifier = "cellDataTitleAccIdentifier"
    public static let surveyCellButtonAccesibilityIdentifier = "arrowBtnIdentifier"
    public static let surveyDetailsViewTitleAccesibilityIdentifier = "surveyDetailsViewTitleAccesibilityIdentifier"


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
    public static let refreshTokenFailedTitle = "Authentication Failed!"
    public static let tryAgain = "Please Try again!"
    public static let refreshTokenFailedDescription = "Try to login again!"
    public static let noInternetAlertTitle = "Connectivity error!"
    public static let apiErrotTitle = "Data Fething Failed!"
    public static let surveyDataFailureDescription = "Survey data not found, please try again later"
    public static let surveyImageFailureDescription = "Survey image not found, please try again later!"

}
