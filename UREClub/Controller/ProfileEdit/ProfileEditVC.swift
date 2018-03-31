//
//  ProfileEditVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 28.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import ALCameraViewController

protocol GenericTextField {}
extension UITextField: GenericTextField {}
extension UITextView: GenericTextField {}

class ProfileEditVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageEditButtonContainer: UIView!
    @IBOutlet weak var profileImageEditButtonImage: UIImageView!
    
    @IBOutlet weak var firstNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var positionField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneField: SkyFloatingLabelTextField!
    @IBOutlet weak var hidePhoneLabel: UILabel!
    @IBOutlet weak var hidePhoneSwitcher: UISwitch!
    @IBOutlet weak var facebookField: SkyFloatingLabelTextField!
    @IBOutlet weak var linkedInField: SkyFloatingLabelTextField!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var userDescriptionTextView: UITextView!
    
    var activeTextField: GenericTextField!
    var currentFrameOriginalY: CGFloat = 0
    var arrayWithTextFields: [SkyFloatingLabelTextField] {
        return [
            firstNameField,
            lastNameField,
            positionField,
            emailField,
            phoneField,
            facebookField,
            linkedInField
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        setUIElementsStyle()
        updateUIWithValues()
        updateUIWithLocalizedText()
        
        hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setDefaultStyle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.makeTransparent()
    }
    
    func setDelegates() {
        
        scrollView.delegate = self
        
        userDescriptionTextView.delegate = self
        for textField in arrayWithTextFields {
            textField.delegate = self
            textField.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
        }
    }
    
    func updateUIWithLocalizedText() {
        
        navigationItem.title = "" // "screen_profile_edit_title".localized()
        let doneButton = UIBarButtonItem(title: "button_save".localized(), style: .plain, target: self, action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.backBarButtonItem?.title = "navbar_button_back".localized()
        
        firstNameField.title = "placeholder_first_name".localized()
        firstNameField.placeholder = "placeholder_first_name".localized()
        
        lastNameField.title = "placeholder_last_name".localized()
        lastNameField.placeholder = "placeholder_last_name".localized()
        
        positionField.title = "placeholder_position".localized()
        positionField.placeholder = "placeholder_position".localized()
        
        emailField.title = "placeholder_email".localized()
        emailField.placeholder = "placeholder_email".localized()
        
        phoneField.title = "placeholder_phone".localized()
        phoneField.placeholder = "placeholder_phone".localized()
        
        hidePhoneLabel.text = "profile_edit_hide_phone".localized()
        descriptionTitleLabel.text = "profile_edit_description_title".localized()
        
    }
    
    func setUIElementsStyle() {
        
        profileImageView.setRadius(64, withWidth: 2, andColor: #colorLiteral(red: 0.4401541352, green: 0.7075563073, blue: 0.9916591048, alpha: 1))
        profileImageView.clipsToBounds = true
        
        profileImageEditButtonContainer.setRadius(16, withWidth: 1, andColor: UIColor.clear)
        let shadowOffset = CGSize(width: 0, height: 1)
        profileImageEditButtonContainer.setShadow(offset: shadowOffset, opacity: 0.5, radius: 5, andColor: UIColor.black)
        
        let lightGreyColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
        let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
        let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
        
        for textField in arrayWithTextFields {
            textField.lineColor = lightGreyColor
            textField.textColor = darkGreyColor
            textField.selectedTitleColor = overcastBlueColor
            textField.selectedLineColor = overcastBlueColor
            textField.font = UIFont(name: "Montserrat-Regular", size: 17)!
            textField.titleFont = UIFont(name: "Montserrat-Bold", size: 14)!
            textField.placeholderFont = UIFont(name: "Montserrat-Bold", size: 14)!
            textField.titleLabel.font = UIFont(name: "Montserrat-Bold", size: 14)!
            textField.titleFormatter = { title in
                return title.lowercased().capitalizingFirstLetter()
            }
        }
        
        userDescriptionTextView.layer.borderWidth = 1
        userDescriptionTextView.layer.borderColor = lightGreyColor.cgColor
    }
    
    func updateUIWithValues() {
        
        profileImageView.sd_setImage(with: URL(string: CurrentUser.linkImage), placeholderImage: UIImage(named: "icon-placeholder-person"))
        
        firstNameField.text = CurrentUser.firstName
        lastNameField.text = CurrentUser.lastName
        positionField.text = CurrentUser.company.position
        emailField.text = CurrentUser.email
        phoneField.text = CurrentUser.phone
        hidePhoneSwitcher.isOn = CurrentUser.isPhoneHidded
        facebookField.text = CurrentUser.facebookLink
        linkedInField.text = CurrentUser.linkedInLink
        userDescriptionTextView.text = CurrentUser.textContent
        
    }
    
    @objc func saveButtonPressed(_ sender: UIBarButtonItem) {
        if doesRequiredFieldsCorrect() {
            updateProfileData()
        }
    }
    
    private func doesRequiredFieldsCorrect() -> Bool {
        var errorMessages = [String]()
        
        if let unwrappedEmail = emailField.text, Validator.isEmailValid(unwrappedEmail) {
        } else {
            errorMessages.append("email_is_not_valid".localized())
        }
        
        if let unwrappedPhone = phoneField.text, Validator.isPhoneValid(unwrappedPhone) {
        } else {
            errorMessages.append("phone_is_not_valid".localized())
        }
        
        if errorMessages.count > 0 {
            let alertTitle = ""
            Alert().presentAlertWith(title: alertTitle, andMessages: errorMessages, completionHandler: { (alertContoller) in
                self.present(alertContoller, animated: true, completion: nil)
            })
            return false
        }
        return true
    }
    
    @IBAction func changeImageButtonPressed(_ sender: UIButton) {
        let croppingParameters = CroppingParameters(isEnabled: true,
                                                    allowResizing: false,
                                                    allowMoving: false,
                                                    minimumSize: CGSize(width: 128, height: 128))
        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true) { [weak self] image, asset in
            if let image = image {
                self?.profileImageView.image = image
                let uploadPhotoData = NetworkManager.UploadPhotoData(photoBody: image)
                NetworkManager().uploadPhoto(uploadPhotoData, completionHandler: { (arrayWithMessages) in
                    self?.dismiss(animated: true, completion: nil)
                })
            } else {
                self?.dismiss(animated: true, completion: nil)
            }
        }
        present(cameraViewController, animated: true, completion: nil)
    }
    
    deinit {
        removeKeyboardNotifications()
    }
}

// MARK: - Helpers
extension ProfileEditVC {
    
    func updateProfileData() {
        let isPhoneHidden: Int = hidePhoneSwitcher.isOn ? 1 : 0
        let updateProfileData = NewNetworkManager.UpdateProfileData(firstname: firstNameField.text,
                                                                    lastname: lastNameField.text,
                                                                    position: positionField.text,
                                                                    email: emailField.text,
                                                                    phone: phoneField.text,
                                                                    hidePhone: isPhoneHidden,
                                                                    facebook: facebookField.text,
                                                                    linkedin: linkedInField.text,
                                                                    description: userDescriptionTextView.text
        )
        
        NewNetworkManager().performRequest(.updateProfile(updateProfileData)) { (resultData) in
            
            switch resultData {
            case .dictWithUpdatedProfile(let data):
                self.updateCurrentUserWith(data)
            case .withErrors(let errors):
                // MARK: Handle errors
                print(errors)
            default:
                break
            }
        }
    }
    
    func updateCurrentUserWith(_ data: [String: Any]) {

        if
            let firstName = data["firstname"] as? String,
            let lastname = data["lastname"] as? String,
            let position = data["position"] as? String,
            let email = data["email"] as? String,
            let phone = data["phone"] as? String,
            let hidePhone = data["hide_phone"] as? Int,
            let facebook = data["facebook"] as? String,
            let linkedin = data["linkedin"] as? String,
            let description = data["description"] as? String
        {
            CurrentUser.firstName = firstName
            CurrentUser.lastName = lastname
            CurrentUser.company.position = position
            CurrentUser.email = email
            CurrentUser.phone = phone
            CurrentUser.isPhoneHidded = Bool(truncating: hidePhone as NSNumber)
            CurrentUser.facebookLink = facebook
            CurrentUser.linkedInLink = linkedin
            CurrentUser.textContent = description
        } else {
            debugLog("Bad Data")
            // MARK: Handle Error
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

// MARK: - Methods, that helps hide Keyboard
extension ProfileEditVC: UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        activeTextField = nil
    }
    
    @objc func textFieldChanged(_ textField: UITextField) {
        guard let skyTextField = textField as? SkyFloatingLabelTextField
            else { return }
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
            if Validator.isPhoneValid(textField.text) {
                textField.errorMessage = ""
            } else {
                textField.errorMessage = "phone_is_not_valid".localized()
            }
        default:
            break
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextField = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextField = nil
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
        guard let keyboardFrame = (userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    func getActiveTextViewFrame() -> CGRect {
        switch activeTextField {
        case let textField as UITextField:
            return textField.frame
        case let textView as UITextView:
            return textView.frame
        default:
            return CGRect.zero
        }
    }
    
    var activeFieldPosition: CGFloat {
        switch activeTextField {
        case let activeTextField as UITextField:
            return self.view.frame.size.height - activeTextField.bounds.height
        case let activeTextView as UITextView:
            return self.view.frame.size.height - activeTextView.bounds.height
        default:
            return self.view.frame.size.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
