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

    @IBOutlet weak var editProfileIcon: UIImageView!
    @IBOutlet weak var temporaryIcon: UIImageView! // Will delete it in the future
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.setRadius(75, withWidth: 2, andColor: #colorLiteral(red: 0.4401541352, green: 0.7075563073, blue: 0.9916591048, alpha: 1))
    }
    
    func updateCellWith(_ contact: GenericContact?) {
        
        if let contact = contact as? Person {
            profileImage.sd_setImage(with: URL(string: contact.getImageLink()), placeholderImage: UIImage(named: "icon-placeholder-person"))
            fullNameLabel.text = contact.firstName + " " + contact.lastName
            companyNameLabel.text = contact.company.name
            positionLabel.text = contact.position
            periodLabel.text = contact.getDateSince()
            
            editProfileIcon.isHidden = true
            temporaryIcon.isHidden = true
        } else {
            profileImage.sd_setImage(with: URL(string: CurrentUser.linkImage), placeholderImage: UIImage(named: "icon-placeholder-person"))
            fullNameLabel.text = CurrentUser.fullName
            companyNameLabel.text = CurrentUser.company.companyName
            positionLabel.text = CurrentUser.company.position
            periodLabel.text = CurrentUser.company.date
        }
    }
}
