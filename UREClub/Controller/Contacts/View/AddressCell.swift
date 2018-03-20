//
//  AddressCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.03.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

protocol AddressCellDelegate: class {
    func didPressOnMap()
}

class AddressCell: UITableViewCell {
    
    weak var delegate: AddressCellDelegate?
    
    @IBAction func didPressOnCell(_ sender: UITapGestureRecognizer) {
        delegate?.didPressOnMap()
    }
}
