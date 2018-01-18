//
//  FilterVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 19.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultBackground()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setDefaultStyle()
    }

}
