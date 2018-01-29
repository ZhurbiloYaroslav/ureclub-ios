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
    }
    
    func setShadow(offset: CGSize, opacity: Float, radius: CGFloat, andColor color: UIColor?) {
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowColor = color?.cgColor
    }
    
}

// MARK: Delete it in the future
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue  }
        get { return layer.cornerRadius }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set { layer.borderColor = newValue?.cgColor  }
        get {
            if let color = layer.borderColor {
                return UIColor.init(cgColor: color)
            } else {
                return nil
            }
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        set { layer.shadowOffset = newValue  }
        get { return layer.shadowOffset }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set { layer.shadowOpacity = newValue }
        get { return layer.shadowOpacity }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        set {  layer.shadowRadius = newValue }
        get { return layer.shadowRadius }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        set { layer.shadowColor = newValue?.cgColor }
        get {
            if let color = layer.shadowColor {
                return UIColor.init(cgColor: color)
            } else {
                return nil
            }
        }
    }
    
    @IBInspectable var _clipsToBounds: Bool {
        set { clipsToBounds = newValue }
        get { return clipsToBounds }
    }
    
}

