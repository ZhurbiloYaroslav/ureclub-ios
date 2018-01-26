//
//  ChangePasswordCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 07.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class ChangePasswordCell: UITableViewCell {
    
    @IBOutlet weak var changePasswordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func updateCell() {
        changePasswordLabel.text = "settings_cell_password_change".localized()
    }
    
}
