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
        initializeDelegates()
        updateUIWithLocalizedText()
        hideKeyboardWhenTappedAround()
    }
    
    func initializeDelegates() {
        for textField in arrayWithTextFields {
            textField.delegate = self
        }
    }
    
    func updateUIWithLocalizedText() {
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
            if let arrayWithErrors = arrayWithErrors, arrayWithErrors.isEmpty {
                let alertTitle = "password_change_title".localized()
                Alert().presentAlertWith(title: alertTitle, andMessages: arrayWithErrors, completionHandler: { (alertController) in
                    self.present(alertController, animated: true, completion: nil)
                })
            }
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
    
    func setUIElementsStyle() {
        
        currentPasswordField.selectedTitle = "placeholder_password_current".localized()
        newPasswordField.selectedTitle = "placeholder_password_new".localized()
        repeatPasswordField.selectedTitle = "placeholder_password_repeat".localized()
        
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
    
    func validateFieldsAndGetData() -> NetworkManager.ChangePasswordData? {
        
        var errorMessages = [String]()
        var newPassword = ""
        var repeatPassword = ""
        
        if let unwrappedPassword = currentPasswordField.text, Validator.isPasswordValid(unwrappedPassword) == false {
            errorMessages.append("password_is_not_valid_1".localized())
        }
        
        if let unwrappedPassword = newPasswordField.text, Validator.isPasswordValid(unwrappedPassword) {
            newPassword = unwrappedPassword
        } else {
            errorMessages.append("password_is_not_valid_2".localized())
        }
        
        if let unwrappedPassword = repeatPasswordField.text, Validator.isPasswordValid(unwrappedPassword) {
            repeatPassword = unwrappedPassword
        } else {
            errorMessages.append("password_is_not_valid_3".localized())
        }
        
        if newPassword.isEqualTo(repeatPassword) == false {
            errorMessages.append("password_not_equal".localized())
        }
        
        if errorMessages.count > 0 {
            let alertTitle = "auth_alert_error_title".localized()
            Alert().presentAlertWith(title: alertTitle, andMessages: errorMessages, completionHandler: { (alertContoller) in
                self.present(alertContoller, animated: true, completion: nil)
            })
            return nil
        }
        
        return NetworkManager.ChangePasswordData(newPassword: newPassword)
    }
}


