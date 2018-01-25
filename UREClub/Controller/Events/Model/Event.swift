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
    var date: EventDate
    var ticket: Ticket
    var location: Location
    
    init(id: Int, title: String, textContent: String, htmlContent: String, categories: [Category],
         date: EventDate, ticket: Ticket, location: Location) {
        
        self.date = date
        self.ticket = ticket
        self.location = location
        
        super.init(id: id, title: title, textContent: textContent, htmlContent: htmlContent, categories: categories)
    }
    
    convenience init() {
        self.init(id: 0, title: "", textContent: "", htmlContent: "", categories: [Category](),
                  date: EventDate(), ticket: Ticket(id: 0), location: Location())
    }
    
    convenience init(withResult resultDictionary: [String: Any]) {
                
        let id = resultDictionary["id"] as? Int ?? 0
        let title = resultDictionary["title"] as? String  ?? ""
        let htmlContent = resultDictionary["content"] as? String  ?? ""
        let textContent = htmlContent
        
        let dictWithLocation = resultDictionary["location"] as? [String: Any] ?? [String: Any]()
        let location = Location(withResult: dictWithLocation)
        
        let dictWithDate = resultDictionary["date"] as? [String: Any] ?? [String: Any]()
        let date = EventDate(withResult: dictWithDate)
        
        let dictWithTicket = resultDictionary["ticket"] as? [String: Any] ?? [String: Any]()
        let ticket = Ticket(withResult: dictWithTicket)
        
        let categories = [Category]()
        
        self.init(id: id, title: title, textContent: textContent, htmlContent: htmlContent, categories: categories,
                  date: date, ticket: ticket, location: location)
    }
}

extension Event {
    func isRegistrationDisabled() -> Bool {
        if ticket.getID() == 0 {
            return true
        } else {
            return false
        }
    }
}

