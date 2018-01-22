//
//  ProfileHeaderCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 28.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SDWebImage

extension ProfileHeaderCell: GenericCell {
    func getCell() -> Self {
        return self
    }
}

class ProfileHeaderCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.setRadius(60, withWidth: 2, andColor: #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1))
    }
    
    func updateCellWith(_ contact: GenericContact?) {
        
        if let contact = contact as? Person {
            profileImage.sd_setImage(with: URL(string: contact.getImageLink()), placeholderImage: #imageLiteral(resourceName: "icon-user_circle"))
            fullNameLabel.text = contact.firstName + " " + contact.lastName
            companyNameLabel.text = contact.company.name
            positionLabel.text = contact.position
            periodLabel.text = contact.getDateSince()
        } else {
            profileImage.sd_setImage(with: URL(string: CurrentUser.linkImage), placeholderImage: #imageLiteral(resourceName: "icon-user_circle"))
            fullNameLabel.text = CurrentUser.fullName
            companyNameLabel.text = CurrentUser.company.companyName
            positionLabel.text = CurrentUser.company.position
            periodLabel.text = CurrentUser.company.date
        }
    }
}
