//
//  ProfileEditVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 28.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class ProfileEditVC: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageEditButtonImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIElementsStyle()
        updateUIWithValues()
    }
    
    func setUIElementsStyle() {
        profileImageView.setRadius(64, withWidth: 2, andColor: #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1))
        profileImageView.clipsToBounds = true
        
        profileImageEditButtonImage.setRadius(16, withWidth: 1, andColor: UIColor.clear)
    }
    
    func updateUIWithValues() {
        profileImageView.sd_setImage(with: URL(string: CurrentUser.linkImage), placeholderImage: UIImage(named: "icon-placeholder-person"))
    }

    @IBAction func changeImageButtonPressed(_ sender: UIButton) {
        print("---pressed changeImageButton")
    }
}
