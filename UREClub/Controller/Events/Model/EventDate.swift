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
        let currentDate = Formatter.getStringFrom(Date(), withFormat: .ddMMyyyy)
        self.date_beg = currentDate
        self.date_end = currentDate
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
