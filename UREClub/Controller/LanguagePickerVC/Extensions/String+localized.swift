//
//  String+localized.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//
import Foundation

extension String {
    
    func localized() -> String {
        let currentLanguage = LanguageManager.shared.currentLanguage
        return getLocalizedStringForResource(currentLanguage.getLanguageCodeForUsingInApp())
    }
        
    func getLocalizedString(key: String, lang: String, table: String? = nil) -> String? {
        return Bundle(path: Bundle.main.path(forResource: "pl", ofType: "lproj")!)?.localizedString(forKey: self,value: nil,table: nil)
    }
    
    func getLocalizedStringForResource(_ resource: String) -> String {
        guard let path = Bundle.main.path(forResource: resource, ofType: "lproj")
            else { return "Error in path" }
        guard let bundle = Bundle(path: path)
            else { return "Error in bundle" }
        
        var defaultValue = ""
        switch self {
        case "": defaultValue = "<No key>"
        default: defaultValue = "<\(self)>"
        }
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: defaultValue, comment: "")
    }
}
