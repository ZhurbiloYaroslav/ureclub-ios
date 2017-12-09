//
//  Languages.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

struct Languages {
    
    enum Language: String {
        case System
        case English
        case Polish
        case Russian
    }
    
    enum LanguageParameter {
        case LanguageName(forLanguage: Language)
        case LanguageCode
    }
    
    static let currentLanguageCode = Languages.get(.LanguageCode, forLanguage: UserDefaultsManager().language)
    
    static func get(_ parameter: LanguageParameter, forLanguage language: Language) -> String {
        switch parameter {
        case .LanguageName(let forLanguage):
            if let languageName = languageName[language]?[forLanguage] {
                return languageName
            } else {
                return language.rawValue
            }
        case .LanguageCode:
            if let languageCode = languageCode[language] {
                return languageCode
            } else {
                return "Base"
            }
        }
        
    }
    
    static let languageCode: [Language: String] = [
        .English: "Base",
        .Polish: "pl",
        .Russian: "ru"
    ]
    
    static fileprivate let languageName: [Language: [Language: String]] = [
        .English: [
            .English: "English",
            .Polish: "English",
            .Russian: "Английский"
        ],
        .Polish: [
            .English: "Polish",
            .Polish: "Polish",
            .Russian: "Польский"
        ],
        .Russian: [
            .English: "Russian",
            .Polish: "Russian",
            .Russian: "Русский"
        ]
    ]
    
    //TODO: Determine code for System language
    struct System {
        
        static let name = "System"
        
        static let prefLang = Locale.preferredLanguages[0]
        
        static var code: String {
            let languageParts = prefLang.components(separatedBy: "-")
            return languageParts.count > 0 ? languageParts[0] : "Base"
        }
        static var locale: String {
            let languageParts = prefLang.components(separatedBy: "-")
            return languageParts.count > 1 ? languageParts[1] : "Base"
        }
    }
    
    struct English {
        static let name = "English"
        static let code = "Base"
    }
    
    struct Polish {
        static let name = "Польский"
        static let code = "pl"
    }
    
    struct Russian {
        static let name = "Русский"
        static let code = "ru"
    }
    
}

