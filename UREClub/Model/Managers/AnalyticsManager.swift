//
//  AnalyticsManager.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 23.06.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import Firebase

class AnalyticsManager {
    
    private static let kStringUserTypeMember = "member"
    private static let kStringUserTypeWorker = "worker"
    
    private static let kAnalyticsKeyUserID = "urec_user_id"
    private static let kAnalyticsKeyUserFirstName = "urec_user_first_name"
    
    private static let kAnalyticsKeyUserType = "urec_user_type"
    private static let kAnalyticsKeyUserEmail = "urec_user_email"
    private static let kAnalyticsKeyUserLastName = "urec_user_last_name"
    private static let kAnalyticsKeyUserFullName = "urec_user_full_name"
    private static let kAnalyticsKeyUserCompanyID = "urec_user_company_id"
    private static let kAnalyticsKeyUserCompanyName = "urec_user_company_name"
    private static let kAnalyticsKeyUserLastLoginDate = "urec_user_last_login_dat"
    private static let kAnalyticsKeyUserFailedLogin = "urec_login_failed"
    private static let kAnalyticsKeyUserLoggedIn = "urec_logged_in"
    
    private static let kAnalyticsContentTypeArticle = "article"
    private static let kAnalyticsContentTypeEvent = "event"
    private static let kAnalyticsContentTypeNews = "news"
    
    // TODO: Implement variable type
    public static func trackSelectedArticle(_ article: Article?) {
        
        guard let article = article else { return }
        let stringWithID = "id-\(article.getID())"
        
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: stringWithID,
            AnalyticsParameterItemName: article.title,
            AnalyticsParameterContentType: kAnalyticsContentTypeArticle
            ]
        )
        
    }
    
    public static func isItFirstLaunch() {
        let isItFirstLaunch = false
        if isItFirstLaunch {
            // TODO: Make event with first launch
        }
    }
    
    public static func saveUserInfo() {
        
        Analytics.setUserProperty(CurrentUser.getStringWithID(), forName: kAnalyticsKeyUserID)
        Analytics.setUserProperty(CurrentUser.firstName, forName: kAnalyticsKeyUserFirstName)
        Analytics.setUserProperty(CurrentUser.lastName, forName: kAnalyticsKeyUserLastName)
        Analytics.setUserProperty(CurrentUser.fullName, forName: kAnalyticsKeyUserFullName)
        
        Analytics.setUserProperty(CurrentUser.email, forName: kAnalyticsKeyUserEmail)
        
        if CurrentUser.company.companyId == "null" {
            Analytics.setUserProperty(kStringUserTypeMember, forName: kAnalyticsKeyUserType)
            Analytics.setUserProperty(CurrentUser.company.companyId, forName: kAnalyticsKeyUserCompanyID)
            Analytics.setUserProperty(CurrentUser.company.companyName, forName: kAnalyticsKeyUserCompanyName)
        } else {
            Analytics.setUserProperty(kStringUserTypeWorker, forName: kAnalyticsKeyUserType)
        }
        
        Analytics.setUserProperty(Formatter.getStringFrom(Date(), withFormat: .yyyyMMdd), forName: kAnalyticsKeyUserLastLoginDate)
    }
    
    public static func loggedInUserWithEmail(_ userEmail: String) {
        Analytics.logEvent(AnalyticsEventLogin, parameters: [kAnalyticsKeyUserEmail: userEmail]
        )
    }
    
    public static func userFailedToLoginWithMessage(_ arrayWithMessages: [String]) {
        if let firstMessage = arrayWithMessages.first {
            Analytics.logEvent(kAnalyticsKeyUserFailedLogin, parameters: ["reason": firstMessage])
        } else {
            Analytics.logEvent(kAnalyticsKeyUserFailedLogin, parameters: ["reason": "undefined"])
        }
    }
    
}
