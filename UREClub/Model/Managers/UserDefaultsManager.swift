//
//  UserDefaultsManager.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    private let defaults = UserDefaults.standard
    
    private var options: [String: String] {
        
        get {
            return defaults.object(forKey: "options") as? [String: String] ?? [String: String]()
        }
        set {
            defaults.set(newValue, forKey: "options")
            defaults.synchronize()
        }
        
    }
}

// MARK: - Save the last used email and password
extension UserDefaultsManager {
    
    var lastUsedEmail: String {
        get {
            return self.options["lastUsedEmail"] ?? ""
        }
        set {
            self.options["lastUsedEmail"] = newValue
        }
    }
    
    var lastUsedPassword: String {
        get {
            return self.options["lastUsedPassword"] ?? ""
        }
        set {
            self.options["lastUsedPassword"] = newValue
        }
    }
}
