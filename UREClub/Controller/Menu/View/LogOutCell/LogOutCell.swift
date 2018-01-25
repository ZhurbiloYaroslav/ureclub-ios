//
//  LogOutCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SDWebImage

class LogOutCell: UITableViewCell {

    @IBOutlet weak var logOutLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCustomStyle()
    }
    
    func setCustomStyle() {
        self.backgroundColor = Constants.Color.coalLight
    }
    
    func updateCellWith(indexPath: IndexPath) {
        
        logOutLabel.text = "menu_item_logout".localized()
        userNameLabel.text = CurrentUser.fullName
        
        profileImage.setRadius(32, withWidth: 1, andColor: UIColor.clear)
        profileImage.sd_setImage(with: URL(string: CurrentUser.linkImage), placeholderImage: UIImage(named: "icon-placeholder-person"))
    }
    
}
