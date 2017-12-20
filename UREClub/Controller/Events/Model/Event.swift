//
//  Event.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class Event {
    let id: String
    let title: String
    let place: Place
    let date: EventDate
    let imageLinks: [String]
    let description: String
    let content: String
    
    init() {
        self.id = "1"
        self.title = "UREC New Year's party"
        self.place = Place()
        self.date = EventDate()
        self.imageLinks = ["https://ureclub.com/uploaded/2018/33-s.jpg"]
        self.description = "Some description"
        self.content = "Some content"
    }
    
    init(withResult result: Any) {
//        guard let result = result as? [String: String] else { return }
        self.id = ""
        self.title = ""
        self.place = Place()
        self.date = EventDate()
        self.imageLinks = [String]()
        self.description = ""
        self.content = ""
    }
}
