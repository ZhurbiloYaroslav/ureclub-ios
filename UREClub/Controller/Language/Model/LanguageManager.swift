//
//  LanguageManager.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 26.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class LanguageManager {
    
    static let shared = LanguageManager()
    let defaults = UserDefaults.standard
    
    var defaultLanguage: Language {
        return arrayWithLanguages[0]
    }
    
    let arrayWithLanguages: [Language] = [
        .english,
        .russian,
        .ukrainian
    ]
    
    func getNumberOfCells() -> Int {
        return arrayWithLanguages.count
    }
    
    func getLanguageFor(_ indexPath: IndexPath) -> Language {
        return arrayWithLanguages[indexPath.row]
    }
    
    func saveCurrentLanguageWith(_ indexPath: IndexPath) {
        currentLanguage = arrayWithLanguages[indexPath.row]
    }
    
}

// MARK: Getters and Setters
extension LanguageManager {
    
    var currentLanguage: Language {
        get {
            let languageCode = defaults.object(forKey: "current_language_code") as? String ?? self.defaultLanguage.getCode()
            return Language.getLanguageFromStringWithCode(languageCode)
        }
        set {
            let languageCode = newValue.getCode()
            defaults.set(languageCode, forKey: "current_language_code")
            defaults.synchronize()
        }
    }
}

// MARK: Static methods
extension LanguageManager {
    
    static var systemPrefferedLanguage: String {
        return Locale.preferredLanguages[0]
    }
    
    static func getSystemPrefferedLanguageCode() -> String {
        let languageParts = systemPrefferedLanguage.components(separatedBy: "-")
        return languageParts.count > 0 ? languageParts[0] : "Base"
    }
}
