//
//  NavBarVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 14.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class NavBarVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateStyle()
    }

    func updateStyle() {
        
        navigationBar.tintColor = UIColor.white
        navigationBar.barTintColor = Constants.Color.navBar
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationBar.isTranslucent = false
    }
}
