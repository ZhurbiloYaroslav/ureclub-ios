//
//  EventsFilter.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 19.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class EventsFilter: Filter {
        
    private var currentEventPeriod = EventPeriod.upcoming
    private var currentEventViewType = EventViewType.calendar
    
    init() {
        super.init(withType: .events)
    }
    
}

// Event Period
extension EventsFilter {
    
    func setEventPeriodFrom(value: Int) {
        currentEventPeriod = EventPeriod.getTypeForInt(value)
    }
    
    func getEventPeriod() -> EventPeriod {
        return currentEventPeriod
    }
    
    enum EventPeriod {
        case upcoming
        case past
        
        static func getTypeForInt(_ value: Int) -> EventPeriod {
            switch value {
            case 1:
                return .past
            default:
                return .upcoming
            }
        }
    }
}

// Event View Type
extension EventsFilter {
    
    func setEventViewTypeFrom(value: Int) {
        currentEventViewType = EventViewType.getTypeForInt(value)
    }
    
    func getEventViewType() -> EventViewType {
        return currentEventViewType
    }
    
    enum EventViewType {
        case calendar
        case list
        
        static func getTypeForInt(_ value: Int) -> EventViewType {
            switch value {
            case 0:
                return .calendar
            default:
                return .list
            }
        }
    }
}
