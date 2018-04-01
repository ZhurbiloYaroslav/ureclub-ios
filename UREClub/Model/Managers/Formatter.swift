//
//  Formatter.swift
//  Fiskas
//
//  Created by Yaroslav Zhurbilo on 13.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class Formatter {
    
    static func getStringFrom(_ date: Date, withFormat format: DateType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
    
    enum DateType: String {
        case ddMMyyyy = "dd-MM-yyyy"
        case HHmm = "HH:mm"
        case dd = "dd"
        case mm = "MM"
        case mmm = "MMM"
        case yy = "yy"
        case yyyy = "yyyy"
        case weekDay = "E"
    }
    
    static func getDateFrom(_ stringWithDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: stringWithDate) ?? Date()
    }
    
    static func getSinceComponentFromTodayFor(_ date: Date) -> DateComponents {
        let calendar = NSCalendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let todayDate = calendar.startOfDay(for: Date())
        let sinceDate = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.month, .year], from: todayDate, to: sinceDate)
        return components
    }
    
    static func getOnlyDateFrom(dateString: String) -> String {
        return String(dateString.dropLast(9))
    }
}
