//
//  LeftMenuManager.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import Foundation
import SWRevealViewController

protocol LMM {
    
}

class LeftMenuManager {
    
    var menuButton: UIBarButtonItem!
    
    init(menuButton button: UIBarButtonItem) {
        menuButton = button
    }
    
//    func setupLeftMenuForViewController(_ controller: Any) {
//
//        menuButton.target = revealViewController()
//        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//
//        if let viewController = controller as? UIViewController {
//            if revealViewController() != nil {
//                view.addGestureRecognizer(viewController.revealViewController().panGestureRecognizer())
//            }
//        }
//
//        if let tableViewController = controller as? UITableViewController {
//            if revealViewController() != nil {
//                view.addGestureRecognizer(tableViewController.revealViewController().panGestureRecognizer())
//            }
//        }
//
//    }
}
