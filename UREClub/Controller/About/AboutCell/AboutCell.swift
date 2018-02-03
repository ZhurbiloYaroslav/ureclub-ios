//
//  AboutCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 07.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class AboutCell: UITableViewCell {
    
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        updateCell()
    }
    
    func updateCell() {
        cellTitleLabel.text = "about_app_title".localized()
    }
    
}
