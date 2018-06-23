//
//  CurrentUser.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 23.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import SwiftSoup
import KeychainSwift

class CurrentUser {
    
    private static let defaults = UserDefaults.standard
    private static let keychainManager = KeychainSwift()
    
    static func logOut(completionHandler: @escaping SuccessBehaviour) {
        resetUserDataWhenLogOut()
        completionHandler()
    }
    
    static func getFirstAndLastNameFromString(_ name: String) {
        firstName = ""
        lastName = ""
        
        let arrayFromName = name.components(separatedBy: CharacterSet.whitespaces)
        if arrayFromName.count == 1 {
            firstName = arrayFromName[0]
        } else if arrayFromName.count > 1 {
            firstName = arrayFromName[0]
            for partOfName in arrayFromName[1...(arrayFromName.count - 1)] {
                lastName += partOfName + " "
            }
        }
    }
    
    static func getBearerToken() -> String {
        return "Bearer " + authToken
    }
    
    static func resetUserDataWhenLogOut() {
        isLoggedIn = false
        isUserActive = false
        isPhoneHidded = false
        id = 0
        linkImage = ""
        linkedInLink = ""
        facebookLink = ""
        textContent = ""
        firstName = ""
        lastName = ""
        company = CurrentUserCompany()
        email = ""
        password = ""
        phone = Phone()
        authToken = ""
    }
}

// MARK: Current User Variables
extension CurrentUser {
    
    static var isLoggedIn: Bool {
        get {
            return defaults.object(forKey: "currentUserIsLoggedIn") as? Bool ?? false
        }
        set {
            defaults.set(newValue, forKey: "currentUserIsLoggedIn")
            defaults.synchronize()
        }
    }
    
    static var isUserActive: Bool {
        get {
            return defaults.object(forKey: "currentUserIsActive") as? Bool ?? false
        }
        set {
            defaults.set(newValue, forKey: "currentUserIsActive")
            defaults.synchronize()
        }
    }
    
    static var isPhoneHidded: Bool {
        get {
            return defaults.object(forKey: "currentUserPhoneIsHidden") as? Bool ?? false
        }
        set {
            defaults.set(newValue, forKey: "currentUserPhoneIsHidden")
            defaults.synchronize()
        }
    }
    
    static var id: Int {
        get {
            return defaults.object(forKey: "currentUserID") as? Int ?? 0
        }
        set {
            defaults.set(newValue, forKey: "currentUserID")
            defaults.synchronize()
        }
    }
    
    static var linkImage: String {
        get {
            return defaults.object(forKey: "currentUser_ProfileImage_Link") as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: "currentUser_ProfileImage_Link")
            defaults.synchronize()
        }
    }
    
    static var linkedInLink: String {
        get {
            return defaults.object(forKey: "currentUser_LinkedIn_Link") as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: "currentUser_LinkedIn_Link")
            defaults.synchronize()
        }
    }
    
    static var facebookLink: String {
        get {
            return defaults.object(forKey: "currentUser_Facebook_Link") as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: "currentUser_Facebook_Link")
            defaults.synchronize()
        }
    }
    
    static var textContent: String {
        get {
            return defaults.object(forKey: "currentUser_TextContent") as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: "currentUser_TextContent")
            defaults.synchronize()
        }
    }
    
    static var fullName: String {
        var fullName = ""
        if firstName != "" {
            fullName = firstName
        }
        if firstName != "" && lastName != "" {
            fullName = fullName + " "
        }
        if lastName != "" {
            fullName = fullName + lastName
        }
        return fullName
    }
    
    static var firstName: String {
        get {
            return defaults.object(forKey: "currentUser_FirstName") as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: "currentUser_FirstName")
            defaults.synchronize()
        }
    }
    
    static var lastName: String {
        get {
            return defaults.object(forKey: "currentUser_LastName") as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: "currentUser_LastName")
            defaults.synchronize()
        }
    }
    
    static var company = CurrentUserCompany.shared
    
    static var email: String {
        get {
            return defaults.object(forKey: "currentUserEmail") as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: "currentUserEmail")
            defaults.synchronize()
        }
    }
    
    static fileprivate let kUserDefKey_CurrentUserPassword = "currentUserPassword"
    static var password: String {
        get {
            return self.keychainManager.get(kUserDefKey_CurrentUserPassword) ?? ""
        }
        set {
            self.keychainManager.set(newValue, forKey: kUserDefKey_CurrentUserPassword)
        }
    }
    
    static fileprivate let kUserDefKey_CurrentUserPhone = "currentUserPhone"
    static fileprivate let kUserDefKey_PhoneIsHidden = "currentUserPhoneIsHidden"
    static var phone: Phone {
        get {
            let number = defaults.object(forKey: kUserDefKey_CurrentUserPhone) as? String ?? ""
            let hidden = defaults.object(forKey: kUserDefKey_PhoneIsHidden) as? Bool ?? false
            return Phone(number: number, isHidden: hidden)
        }
        set {
            defaults.set(newValue.getNumber(), forKey: kUserDefKey_CurrentUserPhone)
            defaults.set(newValue.isHidden, forKey: kUserDefKey_PhoneIsHidden)
            defaults.synchronize()
        }
    }
    
    static fileprivate let kUserDefKey_CurrentUserToken = "currentUserAuthenticationToken"
    static var authToken: String {
        get {
            return defaults.object(forKey: kUserDefKey_CurrentUserToken) as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: kUserDefKey_CurrentUserToken)
            defaults.synchronize()
        }
    }
}

extension CurrentUser {
    static func getID() -> Int {
        return Int(id)
    }
    
    static func getStringWithID() -> String {
        return String(id)
    }
    
    static func getPhone() -> Phone {
        return phone
    }
    
    // MARK: - Check on Existing of Info
    
    static func facebookLinkIsEmpty() -> Bool {
        let doesFacebookLinkEmpty = facebookLink.trimmingCharacters(in: .whitespaces).isEmpty
        return doesFacebookLinkEmpty
    }
    
    static func linkedInLinkIsEmpty() -> Bool {
        let doesLinkedInLinkEmpty = linkedInLink.trimmingCharacters(in: .whitespaces).isEmpty
        return doesLinkedInLinkEmpty
    }
}

