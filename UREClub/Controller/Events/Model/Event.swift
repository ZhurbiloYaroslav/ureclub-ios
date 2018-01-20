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
    
    init(id: String, title: String, textContent: String, htmlContent: String, categories: [Category], place: Place, date: EventDate) {
        self.place = place
        self.date = date
        
        super.init(id: id, title: title, textContent: textContent, htmlContent: htmlContent, categories: categories)
    }
    
    convenience init() {
        self.init(id: "0", title: "", textContent: "", htmlContent: "", categories: [Category](), place: Place(), date: EventDate())
    }
    
    func getDayFromDate() -> String {
        return "25"
    }
    
    convenience init(withResult resultDictionary: [String: Any]) {
                
        let id = resultDictionary["id"] as? String ?? "0"
        let title = resultDictionary["title"] as? String  ?? ""
        let date_beg = resultDictionary["dateStart"] as? String  ?? ""
        let date_end = resultDictionary["dateStart"] as? String  ?? ""
        let htmlContent = resultDictionary["content"] as? String  ?? ""
        let textContent = htmlContent
        
        let location = resultDictionary["location"] as? [String: Any] ?? [String: Any]()
        let location_id = location["id"] as? String  ?? ""
        let location_name = location["name"] as? String  ?? ""
        let location_city = location["city"] as? String  ?? "Kiev"
        let location_address = location["address"] as? String  ?? "Default address"
        
        let categories = [Category]()
        let place = Place(id: location_id, title: location_name, city: location_city, address: location_address)
        let date = EventDate(date_beg: date_beg, date_end: date_end)
        
        self.init(id: id, title: title, textContent: textContent, htmlContent: htmlContent, categories: categories, place: place, date: date)
    }
}

//TODO: Delete this code
//extension Event: FilterItem {
//    func getItem() -> Self {
//        return self
//    }
//}

