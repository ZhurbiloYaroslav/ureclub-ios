//
//  CompanyCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {

    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateCell()
        collectionView.backgroundColor = Constants.Color.skyDark
        collectionView.setRadius(15, withWidth: 1, andColor: UIColor.clear)
    }
    
    func updateCell() {
        companyNameLabel.text = CurrentUser.company.companyName
        companyImageView.image = UIImage(named: "logo-ureclub")
    }
    
}
