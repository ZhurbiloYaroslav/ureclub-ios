//
//  FieldCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 28.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class FieldCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellText: UILabel!
    @IBOutlet weak var cellField: UITextField!
    @IBOutlet weak var textArea: UITextView!
    
    var isUnderEditing: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        resetCellValues()
    }
    
    func resetCellValues() {
        cellText.text = ""
        cellField.text = ""
        cellText.isHidden = false
        cellField.isHidden = true
        textArea.isHidden = true
    }
    
    func configureWith(_ cellData: CellData) {
        
        cellImage.image = cellData.icon
        cellTitle.text = cellData.title
        cellText.text = cellData.value
        cellField.text = cellData.value
        textArea.text = cellData.value
        
        switch cellData.type {
        case .Text:
            cellImage.isHidden = true
            
            cellTitle.isHidden = true
            
            cellText.textColor = UIColor.darkGray
            cellText.numberOfLines = 0
            cellText.isHidden = isUnderEditing
            
            textArea.isHidden = !isUnderEditing
            textArea.isUserInteractionEnabled = isUnderEditing
        default:
            cellText.isHidden = isUnderEditing
            cellField.isHidden = !isUnderEditing
            cellField.isUserInteractionEnabled = isUnderEditing
            textArea.isHidden = true
        }
    }
    
    struct CellData {
        let type: CellType
        let icon: UIImage
        let title: String
        let value: String
    }
    
}
