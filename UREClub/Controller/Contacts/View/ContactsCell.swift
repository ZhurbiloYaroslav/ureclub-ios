//
//  ContactsCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class ContactsCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    
    var currentPerson: Person!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setDefaultStyle()
    }
    
    func updateCellWith(_ person: Person) {
        
        currentPerson = person
        
        contactImage.setRadius(60, withWidth: 2, andColor: #colorLiteral(red: 0.4401541352, green: 0.7075563073, blue: 0.9916591048, alpha: 1))
        contactImage.sd_setImage(with: URL(string: person.getImageLink()), placeholderImage: #imageLiteral(resourceName: "icon-user_circle"))
        
        fullNameLabel.text = person.fullName
        let atCompanyText = (person.company.name.count > 0) ? " At " + person.company.name : ""
        positionLabel.text = person.position + atCompanyText
        emailButton.setTitle(person.getEmail(), for: .normal)
        phoneButton.setTitle(person.getPhone(), for: .normal)
    }
    
    @IBAction func emailButtonPressed(_ sender: UIButton) {
        Browser.openURLWith(.Mail_User_Email)
    }
    
    @IBAction func phoneButtonPressed(_ sender: UIButton) {
        Browser.openURLWith(.Call_User_Phone)
    }
    
    @IBAction func facebookButtonPressed(_ sender: UIButton) {
        Browser.openURLWith(.Surf_User_Facebook)
    }
    
    @IBAction func linkedInButtonPressed(_ sender: UIButton) {
        Browser.openURLWith(.Surf_User_LinkedIn)
    }
    
}
