//
//  EventsManager.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 19.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

extension EventsManager: NetworkManagerDelegate {
    func didLoad(arrayWithEvents: [Event]) {
        self.arrayWithEvents = arrayWithEvents
    }
}

class EventsManager {
    
    public static var shared = EventsManager()
    
    public var eventsFilter = EventsFilter.shared
    
    private var arrayWithEvents = [Event]()
    private var networkManager = NetworkManager()
    
    private var sectionMonthIndex = [TableSectionIndex: MonthIndex]()
    
    init() {
        networkManager.delegate = self
        getArrayWithEvents { (errors) in }
    }
    
    func getNumberOfEventsIn(_ section: Int) -> Int {
        switch eventsFilter.getEventViewType() {
        case .calendar:
            guard let monthIndex = sectionMonthIndex[section] else {
                return 0
            }
            guard let arrayWithEventsFromMonth = getDictWithEventsByMonths()[monthIndex] else {
                return 0
            }
            return arrayWithEventsFromMonth.count
        case .list:
            return arrayWithEvents.count
        }
    }
    
    func getNumberOfSections() -> Int {
        switch eventsFilter.getEventViewType() {
        case .calendar:
            return getDictWithEventsByMonths().count
        case .list:
            return 1
        }
    }
    
    func getDictWithEventsByMonths() -> [Int: [Event]] {
        if arrayWithEvents.count == 0 {
            return [Int: [Event]]()
        }
        var dictWithEventsByMonths = [Int: [Event]]()
        
        var sectionIndex = 0
        for monthIndex in [0,1,2,3,4,5,6,7,8,9,10,11] {
            var newArrayWithEvents = [Event]()
            for event in arrayWithEvents {
                if event.date.getMonthFromDate() == monthIndex {
                    newArrayWithEvents.append(event)
                }
            }
            if newArrayWithEvents.count > 0 {
                dictWithEventsByMonths.updateValue(newArrayWithEvents, forKey: monthIndex)
                sectionMonthIndex.updateValue(monthIndex, forKey: sectionIndex)
                sectionIndex += 1
            }
        }
        
        return dictWithEventsByMonths
    }
    
    func getHeaderTitleFor(_ section: Int) -> String {
        if eventsFilter.getEventViewType() == .list {
            return ""
        }
        guard let monthIndex = sectionMonthIndex[section] else {
            return ""
        }
        guard let arrayWithEventsBySection = getDictWithEventsByMonths()[monthIndex] else {
            return ""
        }
        
        for monthIndex in [0,1,2,3,4,5,6,7,8,9,10,11] {
            let eventMonth = arrayWithEventsBySection[0].date.getMonthFromDate()
            if eventMonth == monthIndex {
                
                switch monthIndex {
                case 0:  return "January"
                case 1:  return "February"
                case 2:  return "March"
                case 3:  return "April"
                case 4:  return "May"
                case 5:  return "June"
                case 6:  return "July"
                case 7:  return "August"
                case 8:  return "September"
                case 9:  return "October"
                case 10: return "November"
                case 11: return "December"
                default: return "Undefined"
                }
            }
        }
        return ""
    }
    
    func getEventFor(_ indexPath: IndexPath) -> Event {
        switch eventsFilter.getEventViewType() {
        case .calendar:
            
            guard let monthIndex = sectionMonthIndex[indexPath.section] else {
                return Event()
            }
            guard let arrayWithEventsFromMonth = getDictWithEventsByMonths()[monthIndex] else {
                return Event()
            }
            return arrayWithEventsFromMonth[indexPath.row]
            
        case .list:
            return arrayWithEvents[indexPath.row]
        }
    }
    
    func getArrayWithEvents(completionHandler: @escaping (_ errorMessages: [NetworkError]?)->()) {
        networkManager.retrieveInfoForPath(.events) { (errors) in
            completionHandler(errors)
        }
    }
}
