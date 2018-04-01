//
//  EventDate.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

struct EventDate {
    let dateBeg: String
    let timeBeg: String
    let dateEnd: String
    let timeEnd: String
    
    init(dateBeg: String, timeBeg: String, dateEnd: String, timeEnd: String) {
        self.dateBeg = dateBeg
        self.timeBeg = timeBeg
        self.dateEnd = dateEnd
        self.timeEnd = timeEnd
    }
    
    init() {
        let currentDate = Formatter.getStringFrom(Date(), withFormat: .ddMMyyyy)
        let currentTime = Formatter.getStringFrom(Date(), withFormat: .HHmm)
        self.dateBeg = currentDate
        self.timeBeg = currentTime
        self.dateEnd = currentDate
        self.timeEnd = currentTime
    }
    
    init(withResult resultDictionary: [String: Any]) {
        
        let dateBeg = resultDictionary["date_beg"] as? String  ?? ""
        let timeBeg = resultDictionary["time_beg"] as? String  ?? ""
        let dateEnd = resultDictionary["date_end"] as? String  ?? ""
        let timeEnd = resultDictionary["time_end"] as? String  ?? ""
        
        self.init(dateBeg: dateBeg, timeBeg: timeBeg, dateEnd: dateEnd, timeEnd: timeEnd)
    }
    
    func getDateOfBegining() -> Date {
        let stringWithEventDate = dateBeg
        return Formatter.getDateFrom(stringWithEventDate)
    }
    
    func getDateOfEnd() -> Date {
        let stringWithEventDate = dateBeg
        return Formatter.getDateFrom(stringWithEventDate)
    }
    
    func getStringWithDate() -> String {
        let eventDate = getDateOfBegining()
        return Formatter.getStringFrom(eventDate, withFormat: .ddMMyyyy)
    }
    
    func getTimePeriod() -> String {
        let startTime = timeBeg.dropLast(3)
        let endTime = timeEnd.dropLast(3)
        return startTime + " - " + endTime
    }
    
    func getDayFromDate() -> String {
        return Formatter.getStringFrom(getDateOfBegining(), withFormat: .dd)
    }
    
    func getDayOfTheWeekFromDate() -> String {
        return getDateOfBegining().dayOfTheWeek
    }
    
    func getMonthFromDate() -> String {
        let stringWithMonth = Formatter.getStringFrom(getDateOfBegining(), withFormat: .mm)
        if let month = Int(stringWithMonth) {
            return month < 10 ? "0\(month)" : "\(month)"
        } else {
            return "01"
        }
    }
    
    func getShirtStringWithMonthFromDate() -> String {
        let stringWithMonth = Formatter.getStringFrom(getDateOfBegining(), withFormat: .mmm)
        return stringWithMonth
    }
    
    func getYearFromDate() -> Int {
        let stringWithYear = Formatter.getStringFrom(getDateOfBegining(), withFormat: .yy)
        return Int(stringWithYear) ?? 0
    }
    
    func getFullYearFromDate() -> Int {
        let stringWithYear = Formatter.getStringFrom(getDateOfBegining(), withFormat: .yyyy)
        return Int(stringWithYear) ?? 0
    }
}
