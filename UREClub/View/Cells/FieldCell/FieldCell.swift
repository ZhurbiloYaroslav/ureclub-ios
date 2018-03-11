//
//  FieldCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 28.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

extension FieldCell: GenericCell {
    func getCell() -> Self {
        return self
    }
}

class FieldCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellText: UILabel!
    @IBOutlet weak var cellField: UITextField!
    @IBOutlet weak var separatorLine: UIView!
    
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
    }
    
    func configureWith(_ genericCellData: GenericCellData) {
        
        guard let cellData = genericCellData as? CellData else { return }
        
        cellImage.image = cellData.icon
        cellTitle.text = cellData.title
        cellText.text = cellData.value
        cellField.text = cellData.value
        
        switch cellData.type {
        case .text:
            cellImage.isHidden = true
            
            cellTitle.isHidden = true
            separatorLine.isHidden = true
            
            cellText.textColor = UIColor.darkGray
            cellText.numberOfLines = 0
            cellText.isHidden = isUnderEditing
            
        default:
            cellText.isHidden = isUnderEditing
            cellField.isHidden = !isUnderEditing
            cellField.isUserInteractionEnabled = isUnderEditing
        }
    }
    
    struct CellData: GenericCellData {
        let type: CellType
        let icon: UIImage
        let title: String
        let value: String
        
        func getCellData() -> FieldCell.CellData {
            return self
        }
    }
    
}
