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
        
    var currentLanguage: Language {
        get {
            let languageCode = UserDefaults.standard.object(forKey: "current_language_code") as? String ?? self.defaultLanguage.getCode()
            return Language.getLanguageFromStringWithCode(languageCode)
        }
        set {
            let currentLanguageCode = newValue.getCode()
            UserDefaults.standard.set(currentLanguageCode, forKey: "current_language_code")
        }
    }
    
    var defaultLanguage: Language {
        return arrayWithLanguages[1]
    }
    
    let arrayWithLanguages: [Language] = [
        .system,
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
    
}
