//
//  PersonCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SDWebImage

class PersonCell: UITableViewCell {

    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setDefaultStyle()
    }
    
    func updateCellWith(_ person: Person) {
        memberImageView.setRadius(64, withWidth: 1, andColor: UIColor.clear)
        memberImageView.sd_setImage(with: URL(string: person.getImageLink()), placeholderImage: #imageLiteral(resourceName: "icon-user_circle"))
        
        fullNameLabel.text = person.fullName
        companyLabel.text = person.company.name
        positionLabel.text = person.position
    }
    
}
