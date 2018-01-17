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
        
        logOutLabel.text = "Log out"
        userNameLabel.text = CurrentUser.fullName
        
        profileImage.layer.cornerRadius = 32
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.clear.cgColor
        profileImage.sd_setImage(with: URL(string: CurrentUser.linkImage), placeholderImage: #imageLiteral(resourceName: "icon-user_circle"))
    }
    
}
