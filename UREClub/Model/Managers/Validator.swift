//
//  Validator.swift
//  Fiskas
//
//  Created by Yaroslav Zhurbilo on 11.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class Validator {
    
    static func isEmpty(_ value: String?) -> Bool {
        guard let result = value else {
            return true
        }
        return result.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
    }
    
    static func isNameValid(_ name: String?) -> Bool {
        let simpleNameRegEx = "\\A\\w{7,18}\\z"
        // or "^[0-9a-zA-Z\\_]{7,18}$"
        // or ^[a-zA-Z\s]+$
        // or ^[a-zA-Z][a-zA-Z\\s]+$
        
        let simpleName = NSPredicate(format: "SELF MATCHES %@", simpleNameRegEx)
        return simpleName.evaluate(with: name)
    }
    
    static func isEmailValid(_ value: String?) -> Bool {
        guard let email = value else {
            return true
        }
        let trimmedEmail = email.trimmingCharacters(in: CharacterSet.whitespaces)
        
        let simpleEmailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", simpleEmailRegEx)
        return emailTest.evaluate(with: trimmedEmail)
    }
    
    static func isPasswordValid(_ password: String?) -> Bool {
        let simplePasswordRegEx = "(?=.*[A-Za-z0-9]).{6,}"
        
        let simplePassword = NSPredicate(format: "SELF MATCHES %@", simplePasswordRegEx)
        return simplePassword.evaluate(with: password)
    }
    
    static func isPhoneValid(_ phoneNumber: String?) -> Bool {
        guard let phoneNumber = phoneNumber else { return false }
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        let doesPhoneMatch = phoneNumber == filtered
        let isLengthNormal = (phoneNumber.count > 9) && (phoneNumber.count < 15)
        return doesPhoneMatch && isLengthNormal
    }
    
//    static func isPhoneValid(_ phoneString: String?) -> Bool {
//        let phonePatternRegEx = "(?:\\d{2}\\D*){0,2}\\d{4,5}\\D*\\d{4}"
//
//        let phonePattern = NSPredicate(format: "SELF MATCHES %@", phonePatternRegEx)
//        return phonePattern.evaluate(with: phoneString)
//    }
}
