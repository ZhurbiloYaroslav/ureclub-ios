//
//  Browser.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import Foundation

class Browser {
    
    static func openURLWith(_ urlAddress: UrlAdresses) {
        
        if let url = URL(string: urlAddress.rawValue), UIApplication.shared.canOpenURL(url){
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        } else {
            print("can't open")
        }
    }
    enum UrlAdresses: String {
        case Call_UREClub_6753 = "tel://+380442276753"
        case Mail_UREClub_Info = "mailto:info@ureclub.com"
    }
}

