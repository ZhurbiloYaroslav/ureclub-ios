//
//  NewFilter.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 26.02.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class NewFilter {
    
    enum FilterType {
        case events
        case members
    }
    
}

protocol FilterViewModelItem {
    var type: FilterViewModelItemType { get }
    var sectionTitle: String  { get }
    var rowCount: Int { get }
}

extension FilterViewModelItem {
    var rowCount: Int {
        return 1
    }
}

enum FilterViewModelItemType {
    case year
    case category
}
