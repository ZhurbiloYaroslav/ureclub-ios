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
    
    private var sectionIndex = [TableSectionIndex: YearAndMonth]()
    
    init() {
        networkManager.delegate = self
        getArrayWithEvents { (errors) in }
    }
    
    func getFilteredEvents() -> [Event] {
        let eventsFilteredWithUpcomingAndPast = getEventsFilteredWithUpcomingAndPast(arrayWithAllEvents)
        let sortedEvents = sortEvents(eventsFilteredWithUpcomingAndPast)
        let result = getEventsFilteredWithYearAndCategoryFrom(sortedEvents)
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
    
    func sortEvents(_ sourceArrayWithEvents: [Event]) -> [Event] {
        var result = [Event]()
        result = sourceArrayWithEvents.sorted { event1, event2 in
            switch eventsFilter.getEventPeriod() {
            case .upcoming:
                return event1.date.getDateOfBegining() < event2.date.getDateOfBegining()
            case .past:
                return event1.date.getDateOfBegining() > event2.date.getDateOfBegining()
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
            let dictWithEvents = getDictWithEventsByMonths()
            guard let yearAndMonth = sectionIndex[section] else {
                return 0
            }
            guard let arrayWithEventsFromYearAndMonth = dictWithEvents[yearAndMonth] else {
                return 0
            }
            return arrayWithEventsFromYearAndMonth.count
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
    
    func getDictWithEventsByMonths() -> [String: [Event]] {
        let filteredEvents = getFilteredEvents()
        if filteredEvents.count == 0 {
            return [String: [Event]]()
        }
        var dictWithEventsByMonths = [String: [Event]]()
        
        var index = 0
        for event in filteredEvents {
            let year = event.date.getFullYearFromDate()
            let month = event.date.getMonthFromDate()
            let yearAndMonthAsString = "\(year)\(month)"
            if dictWithEventsByMonths[yearAndMonthAsString] == nil {
                dictWithEventsByMonths.updateValue([Event](), forKey: yearAndMonthAsString)
            }
            dictWithEventsByMonths[yearAndMonthAsString]!.append(event)
            
            if sectionIndex.values.contains(yearAndMonthAsString) == false {
                sectionIndex.updateValue(yearAndMonthAsString, forKey: index)
                index += 1
            }
        }
        
        return dictWithEventsByMonths
    }
    
    func getHeaderTitleFor(_ section: Int) -> String {
        if eventsFilter.getEventViewType() == .list {
            return ""
        }
        
        _ = getDictWithEventsByMonths()
        guard let yearAndMonthIndex = sectionIndex[section] else {
            return "month_undefined".localized()
        }
        let currentMonth = yearAndMonthIndex.dropFirst(4)
        let currentYear = yearAndMonthIndex.dropLast(2)
        var title = currentYear + " "
        switch String(currentMonth) {
        case "01": title += "month_01".localized()
        case "02": title += "month_02".localized()
        case "03": title += "month_03".localized()
        case "04": title += "month_04".localized()
        case "05": title += "month_05".localized()
        case "06": title += "month_06".localized()
        case "07": title += "month_07".localized()
        case "08": title += "month_08".localized()
        case "09": title += "month_09".localized()
        case "10": title += "month_10".localized()
        case "11": title += "month_11".localized()
        case "12": title += "month_12".localized()
        default: title += "month_undefined".localized()
        }
        return String(title)
    }
    
    func getEventFor(_ indexPath: IndexPath) -> Event {
        switch eventsFilter.getEventViewType() {
        case .calendar:
            
            let dictWithEvents = getDictWithEventsByMonths()
            guard let yearAndMonthIndex = sectionIndex[indexPath.section] else {
                return Event()
            }
            guard let arrayWithEventsFromYearAndMonth = dictWithEvents[yearAndMonthIndex] else {
                return Event()
            }
            return arrayWithEventsFromYearAndMonth[indexPath.row]
            
        case .list:
            return getFilteredEvents()[indexPath.row]
        }
    }
    
    func getEventByPostID(_ postIDs: [Int]) -> Event? {
        var resultEvent: Event? = nil
        arrayWithAllEvents.forEach { event in
            if postIDs.contains(event.getPostID()) {
                resultEvent = event
            }
        }
        return resultEvent
    }
    
    func getArrayWithEvents(completionHandler: @escaping (_ errorMessages: [NetworkError]?)->()) {
        networkManager.retrieveInfoForPath(.events) { (errors) in
            completionHandler(errors)
        }
    }
}
