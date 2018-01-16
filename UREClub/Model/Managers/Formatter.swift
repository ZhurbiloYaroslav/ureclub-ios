//
//  Formatter.swift
//  Fiskas
//
//  Created by Yaroslav Zhurbilo on 13.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class Formatter {
    static func getFormatted(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
    
    static func getOnlyDateFrom(dateString: String) -> String {
        return String(dateString.dropLast(9))
    }
}
