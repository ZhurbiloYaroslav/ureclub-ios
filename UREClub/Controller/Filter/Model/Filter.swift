//
//  Filter.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class Filter {
    
    var type: FilterType
    var searchString: String
    var filterData = FilterData()
    var arrayWithSections = [FilterSection]()
    var contactsIDToPresentOnly: [Int]?
    
    init(withType type: FilterType) {
        self.type = type
        self.searchString = ""
        self.arrayWithSections = filterData.getArrayWithSectionsDependsOn(type)
        self.contactsIDToPresentOnly = nil
    }
    
    var isInSearch: Bool {
        let isNotInSearch = searchString.isEmpty == false
        return isNotInSearch
    }
    
    var lowerCasedSearchString: String {
        return searchString.lowercased()
    }
    
}

// MARK: Enums and structs
extension Filter {
    
    enum FilterType {
        case events
        case news
        case members
        case contacts
    }
    
    struct FilterSection {
        let title: String
        let type: String
        let arrayWithItems: [FilterSectionItem]
        
        init(title: String, type: String, arrayWithItems: [FilterSectionItem]) {
            self.title = title
            self.type = type
            self.arrayWithItems = arrayWithItems
        }
        
        init(title: String, type: FilterSectionType, arrayWithItems: [FilterSectionItem]) {
            let stringWithType = type.getStringWithType()
            self.init(title: title, type: stringWithType, arrayWithItems: arrayWithItems)
        }
        
        func getNumberOfItems() -> Int {
            return arrayWithItems.count
        }
    }
    
    struct FilterSectionItem {
        let id: String = "0"
        let title: String!
    }
    
    enum FilterSectionType {
        case sort
        case year
        case category
        case starred
        case readingStatus
        case undefined
        
        func getStringWithType() -> String {
            switch self {
            case .sort:
                return "sort"
            case .year:
                return "year"
            case .category:
                return "category"
            case .starred:
                return "starred"
            case .readingStatus:
                return "readingStatus"
            default:
                return "undefined"
            }
        }
        
        static func getSectionTypeFor(_ value: String) -> FilterSectionType {
            switch value {
            case "sort":
                return .sort
            case "year":
                return .year
            case "category":
                return .category
            case "starred":
                return .starred
            case "readingStatus":
                return .readingStatus
            default:
                return .undefined
            }
        }
    }
}

// MARK: GenericFilter
protocol GenericFilter {
    var type: Filter.FilterType { get set }
    var filterData: FilterData { get set }
    var arrayWithSections: [Filter.FilterSection] { get set }
    func getFilter() -> Self
}
extension Filter: GenericFilter {
    func getFilter() -> Self {
        return self
    }
}
