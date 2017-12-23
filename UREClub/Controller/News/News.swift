//
//  News.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 23.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class News {
    var id: Int
    var title: String
    var htmlContent: String
    var description: String
    var imageLinks: [String]
    
    init(id: Int, title: String, description: String, content: String, place: Place, date: EventDate, imageLinks: [String]) {
        self.id = id
        self.title = title
        self.htmlContent = content
        self.description = description
        self.imageLinks = imageLinks
    }
    
    convenience init() {
        self.init(id: 0, title: "", description: "", content: "", place: Place(), date: EventDate(), imageLinks: [""])
    }
    
    convenience init(withResult resultDictionary: [String: Any]) {
        
        let id = resultDictionary["EVT_ID"] as? Int ?? 0
        let title = resultDictionary["EVT_name"] as? String ?? ""
        let content = (resultDictionary["EVT_desc"] as? [String: String] ?? ["rendered":""])["rendered"] ?? ""
        let description = content
        let place = Place()
        let date = EventDate()
        let imageLinks = [String]()
        
        self.init(id: id, title: title, description: description, content: content, place: place, date: date, imageLinks: imageLinks)
    }
}
