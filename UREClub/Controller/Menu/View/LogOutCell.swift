//
//  LogOutCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SDWebImage

protocol LogOutCellDelegate: class {
    func didTapOnProfileIcon()
    func didTapOnCell()
}

class LogOutCell: UITableViewCell {

    @IBOutlet weak var logOutLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    weak var delegate: LogOutCellDelegate?
    
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
        
        profileImage.setRadius(25, withWidth: 1, andColor: UIColor.clear)
        profileImage.sd_setImage(with: URL(string: CurrentUser.linkImage), placeholderImage: UIImage(named: "icon-placeholder-person"))
    }
    
    @IBAction func didTapOnProfileIcon(_ sender: UIButton) {
        delegate?.didTapOnProfileIcon()
    }
    
    @IBAction func didTapOnCell(_ sender: UIButton) {
        delegate?.didTapOnCell()
    }
    
}
