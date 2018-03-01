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
        self.arrayWithAllEvents = arrayWithEvents
    }
}

class EventsManager {
    
    public static var shared = EventsManager()
    
    public var eventsFilter = EventsFilter.shared
    
    private var arrayWithAllEvents = [Event]()
    private var networkManager = NetworkManager()
    
    private var sectionMonthIndex = [TableSectionIndex: MonthIndex]()
    
    init() {
        networkManager.delegate = self
        getArrayWithEvents { (errors) in }
    }
    
    func getFilteredEvents() -> [Event] {
        let eventsFilteredWithUpcomingAndPast = getEventsFilteredWithUpcomingAndPast(arrayWithAllEvents)
        let result = getEventsFilteredWithYearAndCategoryFrom(eventsFilteredWithUpcomingAndPast)
        return result
    }
    
    func getEventsFilteredWithUpcomingAndPast(_ sourceArrayWithEvents: [Event]) -> [Event] {
        var result = [Event]()
        result = sourceArrayWithEvents.filter() { event in
            switch eventsFilter.getEventPeriod() {
            case .upcoming:
                let isDateOfEventInPast = Date() < event.date.getDateOfBegining()
                return isDateOfEventInPast
            case .past:
                let isDateOfEventInFuture = Date() > event.date.getDateOfBegining()
                return isDateOfEventInFuture
            }
        }
        return result
    }
    
    func getEventsFilteredWithYearAndCategoryFrom(_ sourceArrayWithEvents: [Event]) -> [Event] {
        
        let eventsFilteredWithYear = sourceArrayWithEvents.filter() { event in
            guard let chosenYear = eventsFilter.chosenYear else {
                return true
            }
            let doesEventMatchToSelectedYear = chosenYear == event.date.getFullYearFromDate()
            
            return doesEventMatchToSelectedYear
        }
        
        let eventsFilteredWithYearAndCategories = eventsFilteredWithYear.filter() { event in
            guard let chosenCategories = eventsFilter.chosenCategories else {
                return true
            }
            let doesEventMatchToSelectedCategories = chosenCategories.containsAnythingFrom(array: event.getArrayWithAllCategoriesIds())
            
            return doesEventMatchToSelectedCategories
        }
        
        return eventsFilteredWithYearAndCategories
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
            return getFilteredEvents().count
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
        if getFilteredEvents().count == 0 {
            return [Int: [Event]]()
        }
        var dictWithEventsByMonths = [Int: [Event]]()
        
        var sectionIndex = 0
        for monthIndex in [0,1,2,3,4,5,6,7,8,9,10,11] {
            var newArrayWithEvents = [Event]()
            for event in getFilteredEvents() {
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
                case 0:  return "month_01".localized()
                case 1:  return "month_02".localized()
                case 2:  return "month_03".localized()
                case 3:  return "month_04".localized()
                case 4:  return "month_05".localized()
                case 5:  return "month_06".localized()
                case 6:  return "month_07".localized()
                case 7:  return "month_08".localized()
                case 8:  return "month_09".localized()
                case 9:  return "month_10".localized()
                case 10: return "month_11".localized()
                case 11: return "month_12".localized()
                default: return "month_undefined".localized()
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
            return getFilteredEvents()[indexPath.row]
        }
    }
    
    func getArrayWithEvents(completionHandler: @escaping (_ errorMessages: [NetworkError]?)->()) {
        networkManager.retrieveInfoForPath(.events) { (errors) in
            completionHandler(errors)
        }
    }
}
