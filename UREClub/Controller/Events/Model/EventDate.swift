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
    let time_beg: String
    let date_end: String
    let time_end: String
    
    init(date_beg: String, time_beg: String, date_end: String, time_end: String) {
        self.date_beg = date_beg
        self.time_beg = time_beg
        self.date_end = date_end
        self.time_end = time_end
    }
    
    init() {
        let currentDate = Formatter.getStringFrom(Date(), withFormat: .ddMMyyyy)
        let currentTime = Formatter.getStringFrom(Date(), withFormat: .HHmm)
        self.date_beg = currentDate
        self.time_beg = currentTime
        self.date_end = currentDate
        self.time_end = currentTime
    }
    
    init(withResult resultDictionary: [String: Any]) {
        
        let date_beg = resultDictionary["date_beg"] as? String  ?? ""
        let time_beg = resultDictionary["time_beg"] as? String  ?? ""
        let date_end = resultDictionary["date_end"] as? String  ?? ""
        let time_end = resultDictionary["time_end"] as? String  ?? ""
        
        self.init(date_beg: date_beg, time_beg: time_beg, date_end: date_end, time_end: time_end)
    }
    
    func getDateOfBegining() -> Date {
        let stringWithEventDate = date_beg
        return Formatter.getDateFrom(stringWithEventDate)
    }
    
    func getDateOfEnd() -> Date {
        let stringWithEventDate = date_beg
        return Formatter.getDateFrom(stringWithEventDate)
    }
    
    func getStringWithDate() -> String {
        let eventDate = getDateOfBegining()
        return Formatter.getStringFrom(eventDate, withFormat: .ddMMyyyy)
    }
    
    func getTimePeriod() -> String {
        let startTime = Formatter.getStringFrom(getDateOfBegining(), withFormat: .HHmm)
        let endTime = Formatter.getStringFrom(getDateOfEnd(), withFormat: .HHmm)
        return startTime + " - " + endTime
    }
    
    func getDayFromDate() -> String {
        return Formatter.getStringFrom(getDateOfBegining(), withFormat: .dd)
    }
    
    func getMonthFromDate() -> Int {
        let stringWithMonth = Formatter.getStringFrom(getDateOfBegining(), withFormat: .mm)
        return ((Int(stringWithMonth)) ?? 1 ) - 1
    }
    
    func getYearFromDate() -> Int {
        let stringWithYear = Formatter.getStringFrom(getDateOfBegining(), withFormat: .yy)
        return Int(stringWithYear) ?? 0
    }
}
