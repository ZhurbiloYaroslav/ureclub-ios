//
//  MenuCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var menuItemImageIcon: UIImageView!
    @IBOutlet weak var menuItemTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateCellWith(indexPath: IndexPath) {
        
        switch indexPath {
        case [0,0]:
            updateLabelsWith(image: "menu", andTitle: "My Profile")
        case [0,1]:
            updateLabelsWith(image: "menu", andTitle: "Events")
        case [0,2]:
            updateLabelsWith(image: "menu", andTitle: "News")
        case [0,3]:
            updateLabelsWith(image: "menu", andTitle: "Members")
        case [0,4]:
            updateLabelsWith(image: "menu", andTitle: "Contacts")
        case [0,5]:
            updateLabelsWith(image: "menu", andTitle: "Options")
        default:
            break
        }
        
    }
    
    private func updateLabelsWith(image: String, andTitle title: String) {
        menuItemImageIcon.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        menuItemTitleLabel.text = title
    }
    
}

