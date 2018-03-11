//
//  UIView+IBInspectable.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 14.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

extension UIView {
    
    func setRadius(_ radius: CGFloat, withWidth width: CGFloat?, andColor color: UIColor?) {
        layer.cornerRadius = radius
        layer.borderWidth = width ?? 1
        layer.borderColor = color?.cgColor
        self.clipsToBounds = true
    }
    
    func setShadow(offset: CGSize, opacity: Float, radius: CGFloat, andColor color: UIColor?) {
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowColor = color?.cgColor
    }
    
}

