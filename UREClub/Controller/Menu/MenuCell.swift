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
        
        let menuItem = Menu().items[indexPath.row]
        updateLabelsWith(title: menuItem.title, andImage: menuItem.iconName)
        
    }
    
    private func updateLabelsWith(title: String, andImage image: String?) {
        menuItemTitleLabel.text = title
        if let imageName = image {
            menuItemImageIcon.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        }
    }
    
}

