//
//  ProfileFieldCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 28.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class ProfileFieldCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellText: UILabel!
    
    var arrayWithCells: [Cell] = [
        Cell(type: .Email, icon: UIImage(), title: "Email:", value: CurrentUser.email),
        Cell(type: .Call, icon: UIImage(), title: "Phone:", value: CurrentUser.phone),
        Cell(type: .Text, icon: UIImage(), title: "", value: "lorem_ipsum_text".localized())
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellImage.isHidden = true
    }
    
    func configureCellWithType(_ cellType: CellType) {
        
        if cellType == .Text {
            cellImage.isHidden = true
            cellTitle.isHidden = true
            cellText.textColor = UIColor.darkGray
            cellText.numberOfLines = 0
        }
        
        for cell in arrayWithCells {
            if cell.type == cellType {
                cellImage.image = cell.icon
                cellTitle.text = cell.title
                cellText.text = cell.value
            }
        }
    }
    
    struct Cell {
        let type: CellType
        let icon: UIImage
        let title: String
        let value: String
    }
    
    enum CellType {
        case Text
        case Call
        case Skype
        case Viber
        case WhatsApp
        case Email
        case Undefined
    }
    
}
