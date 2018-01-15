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
        case Call_UREClub_6753
        case Mail_UREClub_Info
        case Call_User_Phone
        case Mail_User_Email
        case Surf_User_Facebook
        case Surf_User_LinkedIn
        
        func getAddress() -> String {
            switch self {
            case .Call_UREClub_6753: return "tel://+380442276753"
            case .Mail_UREClub_Info: return "mailto:info@ureclub.com"
            case .Call_User_Phone: return "tel://\(CurrentUser.phone)"
            case .Mail_User_Email: return "mailto:\(CurrentUser.email)"
            case .Surf_User_Facebook: return CurrentUser.facebook_link
            case .Surf_User_LinkedIn: return CurrentUser.linkedIn_link
            }
        }
    }
}

