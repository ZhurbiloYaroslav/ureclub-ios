//
//  UIView+fromNib.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.03.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

extension UIView {
    static func instanceFromNib<T>() -> T {
        return UINib(nibName: String(describing: T.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! T
    }
}
