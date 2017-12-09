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
    
    var language: Languages.Language {
        
        get {
            guard let languageRaw = self.options["language"] else {
                return Constants.defaultLanguage
            }
            return Languages.Language(rawValue: languageRaw) ?? Constants.defaultLanguage
        }
        
        set {
            self.options["language"] = newValue.rawValue
        }
        
    }
}
