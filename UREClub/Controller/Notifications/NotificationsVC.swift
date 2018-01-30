//
//  NotificationsVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 28.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

extension NotificationsVC: StoryboardInitialized {}

class NotificationsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUIWithLocalizedText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setDefaultStyle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.makeTransparent()
    }
    
    func updateUIWithLocalizedText() {
        
        navigationItem.title = "screen_notifications_title".localized()
        navigationItem.backBarButtonItem?.title = "navbar_button_back".localized()
        
    }

}
