//
//  ArticleDataFromPushNotification.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 24.03.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

struct DataFromPushNotification {
    public let postID: Int
    public let postType: String
    
    public var isNews: Bool {
        return postType == "news"
    }
    
    public var isEvent: Bool {
        return postType == "event"
    }
    
    init(withResult additionalData: [String: Any]) {
        
        self.postID = additionalData["postID"] as? Int ?? 0
        self.postType = additionalData["postType"] as? String ?? ""
    }
}