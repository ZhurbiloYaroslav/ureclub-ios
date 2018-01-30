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
    
    var baseLanguage: Language {
        return .english
    }
    
    func getCode() -> String {
        switch self {
        case .system: return LanguageManager.getSystemPrefferedLanguageCode()
        case .english: return "en"
        case .russian: return "ru"
        case .ukrainian: return "uk"
        case .polish: return "pl"
        }
    }
    
    func getLanguageCodeForServer() -> String {
        switch self {
        case .system:
            return LanguageManager.getSystemPrefferedLanguageCode()
        default:
            return getCode()
        }
    }
    
    func getCodeForSavingLanguageInDefaults() -> String {
        switch self {
        case .system:
            return "system"
        default:
            return getCode()
        }
    }
    
    func getLanguageCodeForUsingInApp() -> String {
        switch getCode() {
        case baseLanguage.getCode():
            return "Base"
        default:
            return getCode()
        }
    }
    
    func getNativeName() -> String {
        switch self {
        case .system:
            return "System"
        default:
            let appLanguageCode = getLanguageCodeForUsingInApp()
            let langTranslationKey = getLanguageTranslationKey()
            let defaultValueOnError = "<\(langTranslationKey)>"
            guard let pathForLanguage = Bundle.main.path(forResource: appLanguageCode, ofType: "lproj")
                else { return defaultValueOnError }
            guard let bundleForLanguage = Bundle(path: pathForLanguage)
                else { return defaultValueOnError }
            let translatedName = bundleForLanguage.localizedString(forKey: langTranslationKey,value: defaultValueOnError,table: "Language")
            return translatedName
        }
    }
    
    func getTranslatedName() -> String {
        let langTranslationKey = getLanguageTranslationKey()
        let localizedLanguageName = Bundle.main.localizedString(forKey: langTranslationKey, value: "<\(langTranslationKey)>", table: "Language")
        return localizedLanguageName
    }
    
    func getLanguageTranslationKey() -> String {
        switch self {
        case .system:
            return "language_system"
        default:
            return "language_" + getCode()
        }
    }
    
    static func getLanguageFromStringWithCode(_ stringWithCode: String) -> Language {
        switch stringWithCode {
        case "system": return .system
        case "ru": return .russian
        case "uk": return .ukrainian
        case "pl": return .polish
        default: return .english
        }
    }
    
}
// For the future purposes
extension Language {
    
    func getLocale() -> String {
        switch self {
        case .system:
            let languageParts = LanguageManager.systemPrefferedLanguage.components(separatedBy: "-")
            return languageParts.count > 1 ? languageParts[1] : "Base"
        case .english: return ""
        case .russian: return ""
        case .ukrainian: return ""
        case .polish: return ""
        }
    }
    
}
