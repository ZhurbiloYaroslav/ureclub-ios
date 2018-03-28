//
//  PasswordEditVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 30.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class PasswordEditVC: UIViewController {

    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var restorePasswordButton: UIButton!
    
    @IBOutlet weak var currentPasswordField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPasswordField: SkyFloatingLabelTextField!
    @IBOutlet weak var repeatPasswordField: SkyFloatingLabelTextField!
    
    private var arrayWithTextFields: [SkyFloatingLabelTextField] {
        return [ currentPasswordField, newPasswordField, repeatPasswordField ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIElementsStyle()
        assignTagToViews()
        initializeDelegates()
        updateUIWithLocalizedText()
        hideKeyboardWhenTappedAround()
    }
    
    func initializeDelegates() {
        for textField in arrayWithTextFields {
            textField.delegate = self
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    func assignTagToViews() {
        currentPasswordField.tag = TextFieldTag.currentPassword.rawValue
        newPasswordField.tag = TextFieldTag.newPassword.rawValue
        repeatPasswordField.tag = TextFieldTag.repeatPassword.rawValue
    }
    
    func updateUIWithLocalizedText() {
        
        navigationItem.title = "screen_password_edit_title".localized()
        
        currentPasswordField.placeholder = "enter_password".localized()
        newPasswordField.placeholder = "enter_password".localized()
        repeatPasswordField.placeholder = "enter_password".localized()
        
        changePasswordButton.setTitle("button_password_change".localized(), for: .normal)
        restorePasswordButton.setTitle("button_password_restore".localized(), for: .normal)
    }
    
    // MARK: IBActions
    @IBAction func changePasswordButtonPressed(_ sender: UIButton) {
        
        guard let changePasswordData = validateFieldsAndGetData() else {
            return
        }
        
        NetworkManager().changePassword(changePasswordData) { (arrayWithErrors) in
            
            var alertMessages = ["password_change_message".localized()]
            if let arrayWithErrors = arrayWithErrors {
                alertMessages = arrayWithErrors
            }
            
            let alertTitle = "password_change_title".localized()
            Alert().presentAlertWith(title: alertTitle, andMessages: alertMessages, completionHandler: { (alertController) in
                self.present(alertController, animated: true, completion: nil)
            })
        }
        
    }
    
    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
        
        let resetPasswordData = NetworkManager.ResetPasswordData(email: CurrentUser.email)
        NetworkManager().resetPassword(resetPasswordData) { errorMessages in
            
            let alertTitle = "auth_alert_password_reset_title".localized()
            var alertMessage = ["auth_alert_password_reset_message".localized()]
            if let errorMessages = errorMessages {
                alertMessage = errorMessages
            }
            Alert().presentAlertWith(title: alertTitle, andMessages: alertMessage, completionHandler: { (alertVC) in
                self.present(alertVC, animated: true, completion: nil)
            })
            
        }
    }
    
}

extension PasswordEditVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let _ = validateDataFromTextFields()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let _ = validateDataFromTextFields()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let _ = validateDataFromTextFields()
    }
    
    enum TextFieldTag: Int {
        case currentPassword = 1
        case newPassword = 2
        case repeatPassword = 3
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setUIElementsStyle() {
        
        currentPasswordField.selectedTitle = "placeholder_password_current".localized()
        currentPasswordField.placeholder = "placeholder_password_current".localized()
        currentPasswordField.title = "placeholder_password_current".localized()
        
        newPasswordField.selectedTitle = "placeholder_password_new".localized()
        newPasswordField.placeholder = "placeholder_password_new".localized()
        newPasswordField.title = "placeholder_password_new".localized()
        
        repeatPasswordField.selectedTitle = "placeholder_password_repeat".localized()
        repeatPasswordField.placeholder = "placeholder_password_repeat".localized()
        repeatPasswordField.title = "placeholder_password_repeat".localized()
        
        setStylesForTextFields()
        
        currentPasswordField.isSecureTextEntry = true
        newPasswordField.isSecureTextEntry = true
        repeatPasswordField.isSecureTextEntry = true
        
        changePasswordButton.setRadius(10, withWidth: 1, andColor: UIColor.clear)
    }
    
    func setStylesForTextFields() {
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
        for textField in arrayWithTextFields {
            
            // textField.lineHeight = 0
            // textField.lineColor = UIColor.clear
            
            // textField.textAlignment = .center
            // textField.titleLabel.textAlignment = .center
            
            textField.font = UIFont(name: "Montserrat-Medium", size: 18) ?? UIFont()
            // textField.textColor = UIColor.white
            // textField.titleColor = Constants.Color.skyLight
            // textField.titleFont = UIFont(name: "Montserrat-Medium", size: 16) ?? UIFont()
            textField.editingChanged()
            // textField.placeholderColor = UIColor.white
            textField.placeholderFont = UIFont(name: "Montserrat-Medium", size: 18) ?? UIFont()
            textField.errorColor = Constants.Color.errorColor
            
            // textField.selectedTitleColor = Constants.Color.skyDark
            
        }
    }
    
}

// MARK: Data validation
extension PasswordEditVC {
    
    func validateDataFromTextFields() -> Bool {
        guard let currentPasswordText = currentPasswordField.text else { return false }
        guard let newPasswordText = newPasswordField.text else { return false }
        guard let repeatPasswordText = repeatPasswordField.text else { return false }
        
        print("---touch")
        if Validator.isPasswordValid(currentPasswordText) {
            currentPasswordField.errorMessage = ""
        } else if currentPasswordText.isEmpty {
            currentPasswordField.errorMessage = ""
        } else {
            currentPasswordField.errorMessage = "password_current_is_not_valid".localized()
            return false
        }
        
        if currentPasswordText.isEqualTo(CurrentUser.password) {
            currentPasswordField.errorMessage = ""
        } else {
            currentPasswordField.errorMessage = "password_current_is_not_match".localized()
            return false
        }
        
        if Validator.isPasswordValid(newPasswordText) {
            newPasswordField.errorMessage = ""
        } else if newPasswordText.isEmpty {
            newPasswordField.errorMessage = ""
        } else {
            newPasswordField.errorMessage = "password_new_is_not_valid".localized()
            return false
        }
        
        if Validator.isPasswordValid(repeatPasswordText) {
            repeatPasswordField.errorMessage = ""
        } else if repeatPasswordText.isEmpty {
            repeatPasswordField.errorMessage = ""
        } else {
            repeatPasswordField.errorMessage = "password_repeat_is_not_valid".localized()
            return false
        }
        
        if newPasswordText.isEqualTo(repeatPasswordText) {
            newPasswordField.errorMessage = ""
            repeatPasswordField.errorMessage = ""
        } else {
            newPasswordField.errorMessage = "passwords_not_equal".localized()
            repeatPasswordField.errorMessage = "passwords_not_equal".localized()
            return false
        }
        
        return true
    }
    
    func validateFieldsAndGetData() -> NetworkManager.ChangePasswordData? {
        
        if validateDataFromTextFields() {
            guard let newPassword = newPasswordField.text else { return nil }
            return NetworkManager.ChangePasswordData(newPassword: newPassword)
        } else {
            return nil
        }
        
    }
}
