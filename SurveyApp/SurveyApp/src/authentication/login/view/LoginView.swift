//
//  ViewController.swift
//  SurveyApp
//
//  Created by Asif on 19/3/22.
//

import UIKit

class LoginView: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let spinnerView = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        configureLoginButton()
        configureTextFields()

    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
    }
    
    private func showLoadingSpinner() {
        addChild(spinnerView)
        spinnerView.view.frame = view.frame
        view.addSubview(spinnerView.view)
        spinnerView.didMove(toParent: self)
    }
    
    private func hideLoadingSpinner(){
        spinnerView.willMove(toParent: nil)
        spinnerView.view.removeFromSuperview()
        spinnerView.removeFromParent()
    }
    
    private func showAlertMessage(message : String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setBackgroundColor(){
        self.view.backgroundColor = .white
        let topColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        let bottomColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.view.setGradientBackground(colorTop: topColor, colorBottom: bottomColor)
    }
    
    private func configureTextFields(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.18)
        emailTextField.layer.cornerRadius = UIConstants.emailTextFieldCornerRadius
        
        passwordTextField.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.18)
        passwordTextField.layer.cornerRadius = UIConstants.passwordTextFieldCornerRadius
        
        let attrs = [NSAttributedString.Key.font : UIFont(name:     UIConstants.fontNeuzeitSLTNormal, size: UIConstants.loginButtonfontSize),
                     NSAttributedString.Key.foregroundColor : UIColor.black
        ]
        var attributedText = NSMutableAttributedString(string: TextConstants.emailPlaceholder, attributes:attrs as [NSAttributedString.Key : Any])
        emailTextField.attributedPlaceholder = attributedText
        
        attributedText = NSMutableAttributedString(string: TextConstants.passwordPlaceholder, attributes:attrs as [NSAttributedString.Key : Any])
        passwordTextField.attributedPlaceholder = attributedText

    }
    
    private func configureLoginButton(){
        self.loginButton.layer.cornerRadius = UIConstants.loginButtonCornerRadius
        let  buttonText  = TextConstants.loginText
        let attrs = [NSAttributedString.Key.font : UIFont(name:     UIConstants.fontNeuzeitSLTHeavy, size: UIConstants.loginButtonfontSize),
                     NSAttributedString.Key.foregroundColor : UIColor.black
        ]
        let boldString = NSMutableAttributedString(string: buttonText, attributes:attrs as [NSAttributedString.Key : Any])
        self.loginButton.setAttributedTitle(boldString, for: .normal)
        
    }
}

extension LoginView : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
