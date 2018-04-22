//
//  ArticleDataFromPushNotification.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 24.03.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

struct DataFromPushNotification {
    public let postIDs: [Int]
    public let memberID: Int
    public let postType: String
    
    public var isNews: Bool {
        return postType == "news"
    }
    
    public var isEvent: Bool {
        return postType == "event"
    }
    
    public var isMember: Bool {
        return postType == "member"
    }
    
    init(withResult additionalData: [String: Any]) {
        
        self.postIDs = additionalData["postIDs"] as? [Int] ?? [Int]()
        self.postType = additionalData["postType"] as? String ?? ""
        
        let memberIDString = additionalData["memberID"] as? String ?? "0"
        self.memberID = Int(memberIDString) ?? 0
    }
}
