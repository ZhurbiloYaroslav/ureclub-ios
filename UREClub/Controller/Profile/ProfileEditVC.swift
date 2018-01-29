//
//  ProfileEditVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 28.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

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
    @IBOutlet weak var facebookField: SkyFloatingLabelTextField!
    @IBOutlet weak var linkedInField: SkyFloatingLabelTextField!
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
        }
    }
    
    func updateUIWithLocalizedText() {
        
        navigationItem.title = "screen_notifications_title".localized()
        navigationItem.backBarButtonItem?.title = "navbar_button_back".localized()
        
    }
    
    func setUIElementsStyle() {
        
        profileImageView.setRadius(64, withWidth: 2, andColor: #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1))
        profileImageView.clipsToBounds = true
        
        profileImageEditButtonContainer.setRadius(16, withWidth: 1, andColor: UIColor.clear)
        let shadowOffset = CGSize(width: 0, height: 1)
        profileImageEditButtonContainer.setShadow(offset: shadowOffset, opacity: 0.5, radius: 5, andColor: UIColor.black)
        
        let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
        let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
        let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
        
        for textField in arrayWithTextFields {
            textField.lineColor = lightGreyColor
            textField.lineColor = darkGreyColor
            textField.textColor = darkGreyColor
            textField.selectedTitleColor = overcastBlueColor
            textField.selectedLineColor = overcastBlueColor
        }
    }
    
    func updateUIWithValues() {
        
        profileImageView.sd_setImage(with: URL(string: CurrentUser.linkImage), placeholderImage: UIImage(named: "icon-placeholder-person"))
        
        firstNameField.text = CurrentUser.firstName
        lastNameField.text = CurrentUser.lastName
        positionField.text = CurrentUser.company.position
        phoneField.text = CurrentUser.phone
        emailField.text = CurrentUser.email
        facebookField.text = CurrentUser.facebook_link
        linkedInField.text = CurrentUser.linkedIn_link
        userDescriptionTextView.text = CurrentUser.textContent
        
    }

    @IBAction func changeImageButtonPressed(_ sender: UIButton) {

    }
    
    deinit {
        removeKeyboardNotifications()
    }
}

// Methods, that helps hide Keyboard
extension ProfileEditVC: UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextField = textView
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
        
        var editingTextFieldY: CGFloat = 0
        if let textField = activeTextField as? UITextField {
            editingTextFieldY = textField.convert(textField.bounds.origin, to: nil).y
        }
        else if let textView = activeTextField as? UITextView {
            editingTextFieldY = textView.convert(textView.bounds.origin, to: nil).y + textView.bounds.height
        }
        
        self.currentFrameOriginalY = self.view.frame.origin.y
        
        if editingTextFieldY > keyboardY {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY - (keyboardY)),
                                         width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: self.currentFrameOriginalY, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
