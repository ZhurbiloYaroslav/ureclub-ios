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
        
        tintColor = Constants.Color.coalLight
        
        layer.cornerRadius = 0.0
        layer.borderWidth = 1.5
        layer.borderColor = Constants.Color.coalLight.cgColor
        layer.backgroundColor = Constants.DefaultColor.background.cgColor
        layer.masksToBounds = true
    }

}
