//
//  LanguageCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 26.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class LanguageCell: UITableViewCell {

    @IBOutlet weak var translatedTitleLabel: UILabel!
    @IBOutlet weak var nativeTitleLabel: UILabel!
    
    var currentLanguage: Language!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateCellWith(_ language: Language) {
        currentLanguage = language
        translatedTitleLabel.text = language.getTranslatedName()
        nativeTitleLabel.text = language.getNativeName()
    }

}
