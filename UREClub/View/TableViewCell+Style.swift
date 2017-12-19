//
//  TableViewCell+Style.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 19.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

extension UITableViewCell {

    open override func awakeFromNib() {
        super.awakeFromNib()
        
        setDefaultStyle()
    }
    
    func setDefaultStyle() {
        self.backgroundColor = Constants.Color.skyLight
    }

}
