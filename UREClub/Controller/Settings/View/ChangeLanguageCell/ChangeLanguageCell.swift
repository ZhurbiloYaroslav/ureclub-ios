//
//  ChangeLanguageCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 07.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class ChangeLanguageCell: UITableViewCell {
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var languageName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCell()
    }
    
    func configureCell() {
        cellTitle.text = "settings_cell_language_title".localized()
        languageName.text = Constants.defaultLanguage.rawValue
    }
}
