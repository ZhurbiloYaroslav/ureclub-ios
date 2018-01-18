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
        
    }
    
    func updateCellWith(_ contact: GenericContact?) {
        
        if let contact = contact as? Person {
            profileImage.sd_setImage(with: URL(string: contact.getImageLink()), placeholderImage: #imageLiteral(resourceName: "icon-user_circle"))
            fullNameLabel.text = contact.firstName + " " + contact.lastName
            companyNameLabel.text = contact.company.name
            positionLabel.text = contact.position
            periodLabel.text = CurrentUser.company.date
        } else {
            profileImage.sd_setImage(with: URL(string: CurrentUser.linkImage), placeholderImage: #imageLiteral(resourceName: "icon-user_circle"))
            fullNameLabel.text = CurrentUser.fullName
            companyNameLabel.text = CurrentUser.company.companyName
            positionLabel.text = CurrentUser.company.position
            periodLabel.text = CurrentUser.company.date
        }
        
        
    }
    
}
