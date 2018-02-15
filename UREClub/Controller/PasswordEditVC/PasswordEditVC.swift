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

    @IBOutlet weak var currentPasswordField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPasswordField: SkyFloatingLabelTextField!
    @IBOutlet weak var repeatPasswordField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func changePasswordButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
        
        let resetPasswordData = NetworkManager.ResetPasswordData(email: CurrentUser.email)
        NetworkManager().resetPassword(resetPasswordData) { errorMessages in
            
            if let errorMessages = errorMessages {
                let passwordResetAlertTitle = "auth_alert_password_reset_title".localized()
                Alert().presentAlertWith(title: passwordResetAlertTitle, andMessages: errorMessages, completionHandler: { (alertVC) in
                    self.present(alertVC, animated: true, completion: nil)
                })
            }
            
        }
    }
    
}
