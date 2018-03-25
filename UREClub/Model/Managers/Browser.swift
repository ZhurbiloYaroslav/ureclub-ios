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
    
    static func openURLWith(_ urlAddress: String) {
        
        if let url = URL(string: urlAddress), UIApplication.shared.canOpenURL(url){
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        } else {
            print("can't open")
        }
    }
    
    static func openURLWith(_ urlAddress: UrlAdresses) {
        openURLWith(urlAddress.getAddress())
    }
    
    static func callTo(_ phone: String) {
        let phoneURL = "tel://\(phone)"
        openURLWith(phoneURL)
    }
    
    static func emailTo(_ email: String) {
        let phoneURL = "mailto:\(email)"
        openURLWith(phoneURL)
    }
    
    static func openUREClubOnMap() {
        let baseLink = "http://maps.google.com/maps?&z=10"
        let coordinates = "\(50.4717454)+\(30.5212255)"
        let searchName = "Ukrainian Real Estate Club"
        let linkWithCoordAndName = "\(baseLink)&ll=\(coordinates)&q=\(searchName)"
        let escapedLink = linkWithCoordAndName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        openURLWith(escapedLink!)
    }
    
    enum UrlAdresses {
        case callUREClub6753
        case callUREClub5158
        case mailUREClubInfo
        case callUserPhone
        case mailUserEmail
        case surfUserFacebook
        case surfUserLinkedIn
        case surfUrecWebSite
        case surfUrecFacebook
        case surfUrecLinkedIn
        case soft4Status
        
        func getAddress() -> String {
            switch self {
            case .callUREClub6753: return "tel://+380442276753"
            case .callUREClub5158: return "tel://+380443605158"
            case .mailUREClubInfo: return "mailto:info@ureclub.com"
            case .callUserPhone: return "tel://\(CurrentUser.phone)"
            case .mailUserEmail: return "mailto:\(CurrentUser.email)"
            case .surfUserFacebook: return CurrentUser.facebookLink
            case .surfUserLinkedIn: return CurrentUser.linkedInLink
            case .surfUrecWebSite: return "https://ureclub.com"
            case .surfUrecFacebook: return "https://www.facebook.com/Ukrainian.Real.Estate.Club/"
            case .surfUrecLinkedIn: return "https://www.linkedin.com/company/ukrainian-real-estate-club/"
            case .soft4Status: return "https://soft4status.com"
            }
        }
    }
    
}

