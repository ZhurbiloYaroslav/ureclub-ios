//
//  LoginVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var enterEmailLabel: UILabel!
    @IBOutlet weak var enterPasswordLabel: UILabel!
    
    //TextFields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //Buttons
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var callUsButton: UIButton!
    @IBOutlet weak var restorePasswordButton: UIButton!
    
    private var activeTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeDelegates()
        setFieldsStyles()
        updateUILabelsWithLocalizedText()
    }
    
    func testing() {
        NetworkManager().retrieveInfoForPath(.events_all) { (arrayWithErrors) in
            if let arrayWithErrors = arrayWithErrors {
                print(arrayWithErrors[0].rawValue)
            }
        }
    }
    
    func setFieldsStyles() {
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let placeholderEmail = "placeholder_email".localized()
        let emailPlaceholder = NSAttributedString(string: placeholderEmail, attributes: attributes)
        
        let placeholderPassword = "placeholder_password".localized()
        let passwordPlaceholder = NSAttributedString(string: placeholderPassword, attributes: attributes)
        
        emailField.attributedPlaceholder = emailPlaceholder
        passwordField.attributedPlaceholder = passwordPlaceholder
    }
    
    func initializeDelegates() {
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    func updateUILabelsWithLocalizedText() {
        enterEmailLabel.text = "enter_email".localized()
        enterPasswordLabel.text = "enter_password".localized()
        
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
            errorMessages.append("Email is invalid")
        }
        
        if let unwrappedPassword = passwordField.text, Validator.isPasswordValid(unwrappedPassword) {
            password = unwrappedPassword
        } else {
            errorMessages.append("Password is invalid")
        }
        
        if errorMessages.count > 0 {
            Alert().presentAlertWith(title: "Login Error", andMessages: errorMessages, completionHandler: { (alertContoller) in
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
                print(errorMessages)
            } else {
                print("firstName: ", CurrentUser.firstName)
                print("email: ", CurrentUser.email)
                print("getBearerToken: ", CurrentUser.getBearerToken())
                self.performSegue(withIdentifier: "EnterFromLogin", sender: nil)
            }
        }
    }
    
    @IBAction func callButtonPressed(_ sender: UIButton) {
        Browser.openURLWith(.Call_UREClub_6753)
    }
    
    @IBAction func emailButtonPressed(_ sender: UIButton) {
        Browser.openURLWith(.Mail_UREClub_Info)
    }
    
    deinit {
        removeKeyboardNotifications()
    }

}

// Methods, that helps hide Keyboard
extension LoginVC: UITextFieldDelegate {
    // Tutorial Move textfield up when Keyboard appears https://www.youtube.com/watch?v=AiYCStoj0lc
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
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

