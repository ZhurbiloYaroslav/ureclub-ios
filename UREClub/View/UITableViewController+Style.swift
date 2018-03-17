//
//  UITableViewController+Style.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 19.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

extension UITableViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultStyle()
    }
    
    func setDefaultStyle() {
        self.tableView.backgroundColor = Constants.DefaultColor.background
    }
}
