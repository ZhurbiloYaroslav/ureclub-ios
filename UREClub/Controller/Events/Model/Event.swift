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
    var place: Place
    var date: EventDate
    
    init(id: Int, title: String, textContent: String, htmlContent: String, place: Place, date: EventDate) {
        self.place = place
        self.date = date
        
        super.init(id: id, title: title, textContent: textContent, htmlContent: htmlContent)
    }
    
    convenience init() {
        self.init(id: 0, title: "", textContent: "", htmlContent: "", place: Place(), date: EventDate())
    }
    
    convenience init(withResult resultDictionary: [String: Any]) {
        
        let title = resultDictionary["EVT_name"] as? String  ?? ""
        let renderedContent = resultDictionary["EVT_desc"] as? [String: Any] ?? [String: Any]()
        let htmlContent = renderedContent["rendered"] as? String  ?? ""
        let textContent = htmlContent
        
        let place = Place()
        let date = EventDate()
        let id = resultDictionary["EVT_ID"] as? Int ?? 0
        
        self.init(id: id, title: title, textContent: textContent, htmlContent: htmlContent, place: place, date: date)
    }
}
