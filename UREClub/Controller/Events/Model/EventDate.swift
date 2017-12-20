//
//  EventDate.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

struct EventDate {
    let date_beg: String
    let date_end: String
    
    init(date_beg: String, date_end: String) {
        self.date_beg = date_beg
        self.date_end = date_end
    }
    
    init() {
        self.init(date_beg: "20.12.2017 16:00", date_end: "20.12.2017 19:00")
    }
    
    func getDate() -> String {
        return "20.12.2017"
    }
    
    func getTimePeriod() -> String {
        return "16:00 - 19:00"
    }
}
