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
        .System,
        .English,
        .Russian
    ]
    
    struct Color {
        static let navBar = UIColor(red: 78.0/255.0, green: 136.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        static let blueLight = UIColor(red: 74.0/255.0, green: 160.0/255.0, blue: 213.0/255.0, alpha: 1.0)
        static let blueDark = UIColor(red: 66.0/255.0, green: 142.0/255.0, blue: 190.0/255.0, alpha: 1.0)
        static let skyLight = UIColor(red: 216.0/255.0, green: 233.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        static let skyDark = UIColor(red: 192.0/255.0, green: 207.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        //static let coalLight = UIColor(red: 221.0/255.0, green: 85.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        //static let coalDark = UIColor(red: 221.0/255.0, green: 85.0/255.0, blue: 95.0/255.0, alpha: 1.0)
    }
    
}

