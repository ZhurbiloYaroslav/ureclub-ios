//
//  Filter.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class Filter {
    
    // MARK: -
    // MARK: Data
    
    var type: FilterType
    var filterData = FilterData()
    var arrayWithSections = [FilterSection]()
    
    // MARK: -
    // MARK: Selected parameters for filtration
    
    var contactsIDToPresentOnly: [Int]? // For Members only
    
    var searchString: String
    var chosenYear: Int?
    var chosenCategories: [Int]?
    
    // MARK: -
    // MARK: Main methods
    
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

// MARK: -
// MARK: Enums and structs
extension Filter {
    
    enum FilterType {
        case events
        case news
        case members
        case contacts
    }
    
    struct FilterSection {
        private let title: String
        private let type: FilterSectionType
        private let selection: SelectionType = .single
        private let arrayWithItems: [FilterSectionItem]
        
        init(title: String, type: FilterSectionType, selection: SelectionType, arrayWithItems: [FilterSectionItem]) {
            self.title = title
            self.type = type
            self.arrayWithItems = arrayWithItems
        }
        
        func getFilterType() -> FilterSectionType {
            return type
        }
        
        func getSelectionType() -> FilterSectionType {
            return type
        }
        
        func getTitle() -> String {
            return title
        }
        
        func getArrayWithItems() -> [FilterSectionItem] {
            return arrayWithItems
        }
        
        func getNumberOfItems() -> Int {
            return arrayWithItems.count
        }
        
        enum SelectionType {
            case single
            case multiple
        }
    }
    
    struct FilterSectionItem {
        let id: [Int]
        let title: String
        
        func getArrayWithIDs() -> [Int] {
            return id
        }
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
    var chosenYear: Int? { get set }
    var chosenCategories: [Int]? { get set }
    var arrayWithSections: [Filter.FilterSection] { get set }
    func getFilter() -> Self
}
extension Filter: GenericFilter {
    func getFilter() -> Self {
        return self
    }
}
