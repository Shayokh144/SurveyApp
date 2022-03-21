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
    
    var presenter: LoginViewToPresenterProtocol?
    var spinnerView : SpinnerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        configureLoginButton()
        configureTextFields()
        configureLoadingSpinner()
        addNotificationObserver()
        /*let keyC = KeyChainManager()
        keyC.deleteLoginDataFromKeyChain()*/

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationObserver()
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        presenter?.didTapLoginButton(userEmail: emailTextField.text ?? "", userPassword: passwordTextField.text ?? "")
    }
    
    private func showLoadingSpinner() {
        DispatchQueue.main.async {
            self.addChild(self.spinnerView)
            self.spinnerView.view.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY - UIConstants.spacceForKeyBoard, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(self.spinnerView.view)
            self.spinnerView.didMove(toParent: self)
        }
    }
    
    private func hideLoadingSpinner(){
        DispatchQueue.main.async {
            self.spinnerView.willMove(toParent: nil)
            self.spinnerView.view.removeFromSuperview()
            self.spinnerView.removeFromParent()
        }
    }
    
    private func setBackgroundColor(){
        self.view.backgroundColor = .white
        let topColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        let bottomColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.view.setGradientBackground(colorTop: topColor, colorBottom: bottomColor)
    }
    
    private func configureLoadingSpinner(){
        spinnerView = SpinnerViewController()
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
        var attributedText = NSMutableAttributedString(string: TextConstants.emailPlaceholderText, attributes:attrs as [NSAttributedString.Key : Any])
        emailTextField.attributedPlaceholder = attributedText
        
        attributedText = NSMutableAttributedString(string: TextConstants.passwordPlaceholderText, attributes:attrs as [NSAttributedString.Key : Any])
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
    
    private func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    private func removeNotificationObserver(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func showAlertMessage(title: String, message : String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: TextConstants.okText, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = UIConstants.spacceForKeyBoard
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0
    }
}

extension LoginView : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
// MARK: PresenterToViewProtocol
extension LoginView : LoginPresenterToViewProtocol{
    func showLoadingSpinnerView() {
        self.showLoadingSpinner()
    }
    
    func showErrorPopUp(title : String, message: String) {
        self.hideLoadingSpinner()
        self.showAlertMessage(title: title, message: message)
    }
}
