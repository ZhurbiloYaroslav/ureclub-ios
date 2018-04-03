//
//  NSDate+dayOfTheWeek.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 01.04.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

extension Date {
    public var dayOfTheWeek: String {
        let dayStrings = ["week_day_sun".localized(),
                          "week_day_mon".localized(),
                          "week_day_tue".localized(),
                          "week_day_wed".localized(),
                          "week_day_thu".localized(),
                          "week_day_fri".localized(),
                          "week_day_sat".localized()
        ]
        let dow = Calendar.current.component(.weekday, from: self)
        return dayStrings[dow]
    }
}
