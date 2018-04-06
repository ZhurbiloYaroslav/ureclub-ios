//
//  LoginVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SWRevealViewController

class LoginVC: UIViewController {
    
    @IBOutlet weak var logoBackgroundView: UIView!
    
    //TextFields
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    
    //Buttons
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var callUsButton: UIButton!
    @IBOutlet weak var restorePasswordButton: UIButton!
    
    private var currentAlertVC: UIAlertController!
    private var activeTextField = UITextField()
    private var arrayWithTextFields: [SkyFloatingLabelTextField] {
        return [ emailField, passwordField ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUIElementsStyle()
        initializeDelegates()
        updateUIWithLocalizedText()
        hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
        //setPredefinedEmailAndPassword()
    }
    
    func initializeDelegates() {
        for textField in arrayWithTextFields {
            textField.delegate = self
        }
    }
    
    private func setPredefinedEmailAndPassword() {
        emailField.text = "4872439@gmail.com"
        passwordField.text = "123456"
    }
    
    func updateUIWithLocalizedText() {
        emailField.placeholder = "enter_email".localized()
        passwordField.placeholder = "enter_password".localized()
        
        logInButton.setTitle("button_log_in".localized(), for: .normal)
        restorePasswordButton.setTitle("button_password_restore".localized(), for: .normal)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        var errorMessages = [String]()
        var email = ""
        var password = ""
        
        if let unwrappedEmail = emailField.text, Validator.isEmailValid(unwrappedEmail) {
            email = unwrappedEmail
        } else {
            errorMessages.append("email_is_not_valid".localized())
        }
        
        if let unwrappedPassword = passwordField.text, Validator.isPasswordValid(unwrappedPassword) {
            password = unwrappedPassword
        } else {
            errorMessages.append("password_is_not_valid".localized())
        }
        
        if errorMessages.count > 0 {
            let alertTitle = "auth_alert_error_title".localized()
            Alert().presentAlertWith(title: alertTitle, andMessages: errorMessages, completionHandler: { (alertContoller) in
                self.present(alertContoller, animated: true, completion: nil)
            })
            return
        }
        
        let loginData = NetworkManager.LoginRequestData(
            username: email,
            password: password
        )
        
        NetworkManager().loginWith(loginData) { errorMessages in
            if let errorMessages = errorMessages {
                let alertTitle = "auth_alert_error_title".localized()
                Alert().presentAlertWith(title: alertTitle, andMessages: errorMessages, completionHandler: { (alertVC) in
                    self.present(alertVC, animated: true, completion: nil)
                })
            } else {
                CurrentUser.password = loginData.password
                self.moveToMainScreen()
            }
        }
    }
    
    private func moveToMainScreen() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window,
            let overviewVC = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController {
            window.rootViewController = overviewVC
            window.makeKeyAndVisible()
        }
    }
    
    @IBAction func callButtonPressed(_ sender: UIButton) {
        Browser.openURLWith(.callUREClub6753)
    }
    
    @IBAction func emailButtonPressed(_ sender: UIButton) {
        Browser.openURLWith(.mailUREClubInfo)
    }
    
    @IBAction func restorePasswordButtonPressed(_ sender: UIButton) {
        presentAlertWithEmailTextField()
    }
    
    @IBAction func resetStateForTextFieldOnValueChanged(_ sender: SkyFloatingLabelTextField) {
        sender.errorMessage = ""
    }
    
    deinit {
        removeKeyboardNotifications()
    }

}

// MARK: Methods related with styles
extension LoginVC {
    
    func setUIElementsStyle() {
        
        setLogoWithRoundBackground()
        
        emailField.selectedTitle = "placeholder_email".localized()
        passwordField.selectedTitle = "placeholder_password".localized()
        
        setStylesForTextFields()
        
        passwordField.isSecureTextEntry = true
        
        logInButton.setRadius(10, withWidth: 1, andColor: UIColor.clear)
    }
    
    func setStylesForTextFields() {
        
        for textField in arrayWithTextFields {
            
            textField.lineHeight = 0
            textField.lineColor = UIColor.clear
            
            textField.textAlignment = .center
            textField.titleLabel.textAlignment = .center
            
            textField.font = UIFont(name: "Montserrat-Medium", size: 18) ?? UIFont()
            textField.textColor = UIColor.white
            textField.titleColor = Constants.Color.skyLight
            textField.titleFont = UIFont(name: "Montserrat-Medium", size: 16) ?? UIFont()
            textField.editingChanged()
            textField.placeholderColor = UIColor.white
            textField.placeholderFont = UIFont(name: "Montserrat-Medium", size: 18) ?? UIFont()
            textField.errorColor = Constants.Color.errorColor
            
            textField.selectedTitleColor = Constants.Color.skyDark
            
        }
    }
    
    func setLogoWithRoundBackground() {
        let logoBackgroundRadius = (logoBackgroundView.bounds.height / 2)
        logoBackgroundView.setRadius(logoBackgroundRadius, withWidth: 1, andColor: UIColor.clear)
        logoBackgroundView.clipsToBounds = true
    }
}


// Send Reset Password Request
extension LoginVC {
    
    var passwordResetAlertTitle: String {
        return "auth_alert_password_reset_title".localized()
    }
    
    func presentAlertWithEmailTextField() {
        
        let alertMessage = "auth_alert_password_reset_message".localized()
        
        let alertController = UIAlertController(title: passwordResetAlertTitle, message: alertMessage, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "alert_button_cancel".localized(), style: .cancel, handler: nil)
        let actionSend = UIAlertAction(title: "alert_button_send".localized(), style: .default) { (alertAction) in
            self.validateEmailFieldFor(alertController)
        }
        
        alertController.addAction(actionCancel)
        alertController.addAction(actionSend)
        
        alertController.addTextField { (textField) in
            textField.text = self.emailField.text
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        
        currentAlertVC = alertController
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        guard let fieldText = textField.text else { return }
        var newMessage = ""
        var attributes = [ NSAttributedStringKey.foregroundColor: UIColor.black ]
        
        if Validator.isEmailValid(fieldText) {
            currentAlertVC.actions[1].isEnabled = true
            newMessage = "email_is_valid".localized()
            attributes = [ NSAttributedStringKey.foregroundColor: UIColor.darkGray ]
        } else {
            currentAlertVC.actions[1].isEnabled = false
            newMessage = "email_is_not_valid".localized()
            attributes = [ NSAttributedStringKey.foregroundColor: UIColor.red ]
        }
        
        let attributedString = NSAttributedString(string: newMessage, attributes: attributes)
        currentAlertVC.setValue(attributedString, forKey: "attributedMessage")
        
    }
    
    func validateEmailFieldFor(_ alertController: UIAlertController) {
        guard let emailTextField = alertController.textFields?[0], let email = emailTextField.text else {
            return
        }
        if Validator.isEmailValid(email) {
            sendResetPasswordFor(email)
        } else {
            let alertMessage = "email_is_not_valid".localized()
            alertController.message = alertMessage
        }
    }
    
    func sendResetPasswordFor(_ email: String) {
        
        let resetPasswordData = NetworkManager.ResetPasswordData(email: email)
        NetworkManager().resetPassword(resetPasswordData) { errorMessages in
            
            if let errorMessages = errorMessages {
                
                Alert().presentAlertWith(title: self.passwordResetAlertTitle, andMessages: errorMessages, completionHandler: { (alertVC) in
                    self.present(alertVC, animated: true, completion: nil)
                })
            }
        }
        
    }
    
}

// Methods, that helps hide Keyboard
extension LoginVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let skyTextField = textField as? SkyFloatingLabelTextField else {
            return
        }
        
        validateTextField(skyTextField)
        
    }
    
    func validateTextField(_ textField: SkyFloatingLabelTextField) {
        switch textField.tag {
        case 1:
            if Validator.isEmailValid(textField.text) {
                textField.errorMessage = ""
            } else {
                textField.errorMessage = "email_is_not_valid".localized()
            }
        case 2:
            if Validator.isPasswordValid(textField.text) {
                textField.errorMessage = ""
            } else {
                textField.errorMessage = "password_is_not_valid".localized()
            }
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        guard let keyboardFrameSize = (userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        let keyboardY = self.view.frame.size.height - keyboardFrameSize.height
        let editingTextFieldY = activeTextField.convert(activeTextField.bounds.origin, to: nil).y
        
        if editingTextFieldY > keyboardY - 90 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY - (keyboardY - 90)),
                                         width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
}

