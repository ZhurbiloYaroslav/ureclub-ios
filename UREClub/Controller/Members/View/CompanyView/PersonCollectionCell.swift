//
//  MemberPersonCollCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class PersonCollectionCell: UICollectionViewCell {
    @IBOutlet weak var personImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = Constants.Color.skyLight
    }
    
    func updateCellWith(_ person: Person) {
        personImageView.sd_setImage(with: URL(string: person.getImageLink()), placeholderImage: UIImage(named: "icon-attend-person"))
    }
    
}
