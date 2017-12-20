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
        static let blueLight = #colorLiteral(red: 0.2901960784, green: 0.6274509804, blue: 0.8352941176, alpha: 1) //4AA0D5 //UIColor(red: 74.0/255.0, green: 160.0/255.0, blue: 213.0/255.0, alpha: 1.0)
        static let blueDark = #colorLiteral(red: 0.2588235294, green: 0.5568627451, blue: 0.7450980392, alpha: 1) //428EBE //UIColor(red: 66.0/255.0, green: 142.0/255.0, blue: 190.0/255.0, alpha: 1.0)
        static let skyLight = UIColor(red: 216.0/255.0, green: 233.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        static let skyDark = UIColor(red: 192.0/255.0, green: 207.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        static let coalLight = #colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.3254901961, alpha: 1) //454553 //UIColor(red: 69.0/255.0, green: 69.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        static let coalDark =  #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2901960784, alpha: 1) //3D3D4A //UIColor(red: 61.0/255.0, green: 61.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    }
    
}
