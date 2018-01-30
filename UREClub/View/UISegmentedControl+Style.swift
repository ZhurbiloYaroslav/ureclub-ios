//
//  UISegmentedControl.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 19.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    
    open override func awakeFromNib() {
        setDefaultStyle()
    }
    
    func setDefaultStyle() {
        self.layer.borderWidth = 1
        self.layer.borderColor = Constants.Color.coalLight.cgColor
        self.backgroundColor = Constants.Color.coalLight
        self.tintColor = Constants.DefaultColor.background
    }

}
