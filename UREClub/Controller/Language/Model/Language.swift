//
//  Language.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 26.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

enum Language {
    
    case system
    case english
    case russian
    case ukrainian
    case polish
    
    var systemPrefferedLanguage: String {
        return Locale.preferredLanguages[0]
    }
    
    func getCode() -> String {
        switch self {
        case .system:
            let languageParts = systemPrefferedLanguage.components(separatedBy: "-")
            return languageParts.count > 0 ? languageParts[0] : "Base"
        case .english: return "en"
        case .russian: return "ru"
        case .ukrainian: return "uk"
        case .polish: return "pl"
        }
    }
    
    func getCodeForUsingInApp() -> String {
        switch getCode() {
        case "en":
            return "Base"
        default:
            return getCode()
        }
    }
    
    func getName() -> String {
        switch self {
        case .system: return "System"
        case .english: return "English"
        case .russian: return "Russian"
        case .ukrainian: return "Ukrainian"
        case .polish: return "Polish"
        }
    }
    
    func getTranslatedName() -> String {
        let languageName = "language_" + getCode()
        let localizedLanguageName = Bundle.main.localizedString(forKey: languageName, value: nil, table: "Language")
        return localizedLanguageName
    }
    
    static func getLanguageFromStringWithCode(_ stringWithCode: String) -> Language {
        switch stringWithCode {
        case "ru": return .russian
        case "uk": return .ukrainian
        default: return .english
        }
    }
    
}
// For the future purposes
extension Language {
    func getLocale() -> String {
        switch self {
        case .system:
            let languageParts = systemPrefferedLanguage.components(separatedBy: "-")
            return languageParts.count > 1 ? languageParts[1] : "Base"
        case .english: return ""
        case .russian: return ""
        case .ukrainian: return ""
        case .polish: return ""
        }
    }
}
