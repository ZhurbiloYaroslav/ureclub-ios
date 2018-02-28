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
    
    func getCustomHeaderViewWith(_ headerTitleText: String) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 36))
        headerView.backgroundColor = Constants.Color.tableSectionsBackground
        
        let headerTitleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.size.width, height: 36))
        headerTitleLabel.text = headerTitleText
        headerTitleLabel.font = UIFont(name: "Montserrat-Medium", size: 15)
        headerTitleLabel.textColor = Constants.Color.tableSectionsTitle
        
        headerView.addSubview(headerTitleLabel)
        return headerView
    }
}
