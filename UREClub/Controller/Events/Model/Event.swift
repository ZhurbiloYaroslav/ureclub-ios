//
//  Event.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import SwiftSoup

class Event {
    var id: Int
    var title: String
    var htmlContent: String
    var description: String
    var place: Place
    var date: EventDate
    var imageLinks: [String]! {
        do{
            var arrayWithImageLinks = [String]()
            let doc: Document = try! SwiftSoup.parse(htmlContent)
            
            description = try! doc.body()?.text() ?? ""
            
            for link in try! doc.select("img").array() {
                arrayWithImageLinks.append(try! link.attr("src"))
            }
            arrayWithImageLinks.uniqInPlace()
            
            return arrayWithImageLinks
        }
    }
    
    init(id: Int, title: String, description: String, htmlContent: String, place: Place, date: EventDate) {
        self.id = id
        self.title = title
        self.htmlContent = htmlContent
        self.description = description
        self.place = place
        self.date = date
    }
    
    convenience init() {
        self.init(id: 0, title: "", description: "", htmlContent: "", place: Place(), date: EventDate())
    }
    
    convenience init(withResult resultDictionary: [String: Any]) {
        
        let id = resultDictionary["EVT_ID"] as? Int ?? 0
        let title = resultDictionary["EVT_name"] as? String ?? ""
        let htmlContent = (resultDictionary["EVT_desc"] as? [String: String] ?? ["rendered":""])["rendered"] ?? ""
        let description = htmlContent
        let place = Place()
        let date = EventDate()
        
        self.init(id: id, title: title, description: description, htmlContent: htmlContent, place: place, date: date)
    }
}
