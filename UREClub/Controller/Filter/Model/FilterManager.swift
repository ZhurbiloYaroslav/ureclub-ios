//
//  FilterManager.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

protocol FilterItem {
    /// Returns generic Item for using in Filter
    func getItem() -> Self
}

class FilterManager {
    
//    func getAllRecords(with type: FilterType) -> [FilterItem] {
//        
//    }
    
    enum FilterType {
        case Event(arrayWithEvents: [Event])
        case News(arrayWithNews: [News])
        case Member(arrayWithMembers: [Contact])
    }
}
