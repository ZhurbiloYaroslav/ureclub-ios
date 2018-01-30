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
        
        if let url = URL(string: urlAddress.getAddress()), UIApplication.shared.canOpenURL(url){
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        } else {
            print("can't open")
        }
    }
    
    enum UrlAdresses {
        case callUREClub6753
        case mailUREClubInfo
        case callUserPhone
        case mailUserEmail
        case surfUserFacebook
        case surfUserLinkedIn
        
        func getAddress() -> String {
            switch self {
            case .callUREClub6753: return "tel://+380442276753"
            case .mailUREClubInfo: return "mailto:info@ureclub.com"
            case .callUserPhone: return "tel://\(CurrentUser.phone)"
            case .mailUserEmail: return "mailto:\(CurrentUser.email)"
            case .surfUserFacebook: return CurrentUser.facebookLink
            case .surfUserLinkedIn: return CurrentUser.linkedInLink
            }
        }
    }
}

