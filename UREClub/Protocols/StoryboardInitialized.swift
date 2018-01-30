//
//  StoryboardInitialized.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 30.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

protocol StoryboardInitialized {}

extension StoryboardInitialized {
    static func storyboardInstance() -> Self? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? Self
    }
}
