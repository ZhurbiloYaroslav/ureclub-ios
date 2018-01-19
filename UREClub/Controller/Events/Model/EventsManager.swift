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
    
    private var arrayWithEvents = [Event]()
    
    private var eventsFilter = EventsFilter.shared
    private var networkManager = NetworkManager()
    
    init() {
        networkManager.delegate = self
        getArrayWithEvents { (errors) in }
    }
    
    func getNumberOfEvents() -> Int {
        return arrayWithEvents.count
    }
    
    func getNumberOfSections() -> Int {
        return 1
    }
    
    func getEventFor(_ indexPath: IndexPath) -> Event {
        return arrayWithEvents[indexPath.row]
    }
    
    func getArrayWithEvents(completionHandler: @escaping (_ errorMessages: [NetworkError]?)->()) {
        networkManager.retrieveInfoForPath(.events) { (errors) in
            completionHandler(errors)
        }
    }
    
}
