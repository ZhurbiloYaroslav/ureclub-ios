//
//  CodexVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 14.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SWRevealViewController

class CodexVC: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCustomBackground()
        updateUILabelsWithLocalizedText()
        setupLeftMenu()
    }
    
    func updateUILabelsWithLocalizedText() {
        
        navigationItem.title = "Code of ethics"
        
    }
    
    func setupLeftMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
}
