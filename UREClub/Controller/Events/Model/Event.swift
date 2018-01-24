//
//  Event.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import SwiftSoup

class Event: Article {
    //var ids: [Int]
    var location: Location
    var date: EventDate
    
    init(id: Int, title: String, textContent: String, htmlContent: String, categories: [Category], location: Location, date: EventDate) {
        self.location = location
        self.date = date
        
        super.init(id: id, title: title, textContent: textContent, htmlContent: htmlContent, categories: categories)
    }
    
    convenience init() {
        self.init(id: 0, title: "", textContent: "", htmlContent: "", categories: [Category](), location: Location(), date: EventDate())
    }
    
    convenience init(withResult resultDictionary: [String: Any]) {
                
        let id = resultDictionary["id"] as? Int ?? 0
        let title = resultDictionary["title"] as? String  ?? ""
        let htmlContent = resultDictionary["content"] as? String  ?? ""
        let textContent = htmlContent
        
        let dictWithLocation = resultDictionary["location"] as? [String: Any] ?? [String: Any]()
        let location = Location(withResult: dictWithLocation)
        
        let dictWithDate = resultDictionary["location"] as? [String: Any] ?? [String: Any]()
        let date = EventDate(withResult: dictWithDate)
        
        let categories = [Category]()
        
        self.init(id: id, title: title, textContent: textContent, htmlContent: htmlContent, categories: categories, location: location, date: date)
    }
}

