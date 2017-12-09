//
//  Constants.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import Foundation

struct Constants {
    
    static let defaultLanguage = Constants.languages[0]
    
    static let languages: [Languages.Language] = [
        .Polish,
        .System,
        .English,
        .Russian
    ]
    
    struct Color {
        static let red = UIColor(red: 221.0/255.0, green: 85.0/255.0, blue: 95.0/255.0, alpha: 1.0)
    }
    
}

