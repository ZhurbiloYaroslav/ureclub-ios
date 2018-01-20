//
//  EventsFilter.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 19.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class EventsFilter: Filter {
    
    public static var shared = EventsFilter()
    
    private var currentEventPeriod = EventPeriod.Upcoming
    private var currentEventViewType = EventViewType.Calendar
    
    init() {
        super.init(withType: .events)
    }
    
}

// Event Period
extension EventsFilter {
    
    func setEventPeriodFrom(value: Int) {
        currentEventPeriod = EventPeriod.getTypeForInt(value)
    }
    
    func getEventPeriodFrom() -> EventPeriod {
        return currentEventPeriod
    }
    
    enum EventPeriod {
        case Upcoming
        case Past
        
        static func getTypeForInt(_ value: Int) -> EventPeriod {
            switch value {
            case 0:
                return .Upcoming
            default:
                return .Past
            }
        }
    }
}

// Event View Type
extension EventsFilter {
    
    func setEventViewTypeFrom(value: Int) {
        currentEventViewType = EventViewType.getTypeForInt(value)
    }
    
    func getEventViewTypeFrom() -> EventViewType {
        return currentEventViewType
    }
    
    enum EventViewType {
        case Calendar
        case List
        
        static func getTypeForInt(_ value: Int) -> EventViewType {
            switch value {
            case 0:
                return .Calendar
            default:
                return .List
            }
        }
    }
}
