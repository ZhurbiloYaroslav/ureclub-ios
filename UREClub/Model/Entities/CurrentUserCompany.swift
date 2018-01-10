//
//  CurrentUserCompany.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 28.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class CurrentUserCompany {
    
    static var shared = CurrentUserCompany()
    
    private let defaults = UserDefaults.standard
    
    var companyId: String {
        get {
            return defaults.object(forKey: "currentCompanyID") as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: "currentCompanyID")
            defaults.synchronize()
        }
    }
    var companyName: String {
        get {
            return defaults.object(forKey: "currentCompanyName") as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: "currentCompanyName")
            defaults.synchronize()
        }
    }
    var position: String {
        get {
            return defaults.object(forKey: "currentCompanyPosition") as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: "currentCompanyPosition")
            defaults.synchronize()
        }
    }
    var date: String {
        get {
            return defaults.object(forKey: "currentCompanyDate") as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: "currentCompanyDate")
            defaults.synchronize()
        }
    }
}
