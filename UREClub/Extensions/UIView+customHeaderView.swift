//
//  UIView+customHeaderView.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.03.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

extension UIView {
    
    static func getCustomHeaderViewWith(_ headerTitleText: String, forTableView tableView: UIView) -> UIView {
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
