//
//  CurrentUser.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 23.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import SwiftSoup
//import KeychainSwift

class CurrentUser {
    
    private static let defaults = UserDefaults.standard
    
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
        id = ""
        linkImage = ""
        linkedInLink = ""
        facebookLink = ""
        textContent = ""
        firstName = ""
        lastName = ""
        company = CurrentUserCompany()
        email = ""
        password = ""
        phone = ""
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
    
    static var id: String {
        get {
            return defaults.object(forKey: "currentUserID") as? String ?? ""
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
    
    static var password: String {
        get {
            return defaults.object(forKey: "currentUserPassword") as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: "currentUserPassword")
            defaults.synchronize()
        }
    }
    
    static var phone: String {
        get {
            return defaults.object(forKey: "currentUserPhone") as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: "currentUserPhone")
            defaults.synchronize()
        }
    }
    
    static var authToken: String {
        get {
            return defaults.object(forKey: "currentUserAuthenticationToken") as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: "currentUserAuthenticationToken")
            defaults.synchronize()
        }
    }
}

