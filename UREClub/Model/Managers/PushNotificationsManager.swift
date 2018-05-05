//
//  PushNotificationsManager.swift
//  QuitSmokingTogether
//
//  Created by Yaroslav Zhurbilo on 28.04.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import OneSignal

class PushNotificationsManager {
    
    public static func handlePushNotifications() {
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        saveTagInfo()
    }
    
    public static func saveTagInfo() {
        OneSignal.sendTag("first_name", value: CurrentUser.firstName)
        OneSignal.sendTag("last_name", value: CurrentUser.lastName)
        OneSignal.sendTag("email", value: CurrentUser.email)
        OneSignal.sendTag("phone", value: CurrentUser.phone.getNumber())
    }
}
