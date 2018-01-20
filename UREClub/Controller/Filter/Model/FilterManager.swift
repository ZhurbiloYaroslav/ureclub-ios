//
//  FilterManager.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class FilterManager {
    
    var type: FilterType!
    var arrayWithSections: [FilterSection]!
    
    init(withType type: FilterType) {
        self.type = type
        arrayWithSections = getArrayWithSectionsDependsOn(type)
    }
    
    func getArrayWithSectionsDependsOn(_ type: FilterType) -> [FilterSection] {
        switch type {
        case .event, .news:
            return [
                FilterSection(title: "Year", type: .date, arrayWithItems:
                    [
                        FilterSection.FilterItem(title: "2018"),
                        FilterSection.FilterItem(title: "2017"),
                        FilterSection.FilterItem(title: "2016")
                    ]
                ),
                FilterSection(title: "Type", type: .category, arrayWithItems:
                    [
                        FilterSection.FilterItem(title: "Forums/Conferences"),
                        FilterSection.FilterItem(title: "Business lunches"),
                        FilterSection.FilterItem(title: "Legal committees"),
                        FilterSection.FilterItem(title: "International events"),
                        FilterSection.FilterItem(title: "Informal")
                    ]
                ),
                FilterSection(title: "Sorting", type: .date, arrayWithItems:
                    [
                        FilterSection.FilterItem(title: "Newer"),
                        FilterSection.FilterItem(title: "Older")
                    ]
                ),
                FilterSection(title: "Status", type: .date, arrayWithItems:
                    [
                        FilterSection.FilterItem(title: "All"),
                        FilterSection.FilterItem(title: "Not read"),
                        FilterSection.FilterItem(title: "Read")
                    ]
                ),
                FilterSection(title: "Starred", type: .date, arrayWithItems:
                    [
                        FilterSection.FilterItem(title: "All"),
                        FilterSection.FilterItem(title: "Starred"),
                        FilterSection.FilterItem(title: "Not starred")
                    ]
                ),
            ]
        case .members:
            return [
                FilterSection(title: "Sort by", type: .date, arrayWithItems:
                    [
                        FilterSection.FilterItem(title: "Recently joined"),
                        FilterSection.FilterItem(title: "A-Z"),
                        FilterSection.FilterItem(title: "Z-A")
                    ]
                ),
                FilterSection(title: "Occupation", type: .category, arrayWithItems:
                    [
                        FilterSection.FilterItem(title: "Residential"),
                        FilterSection.FilterItem(title: "Commercial"),
                        FilterSection.FilterItem(title: "Architecture"),
                        FilterSection.FilterItem(title: "Consulting"),
                        FilterSection.FilterItem(title: "Legal")
                    ]
                )
            ]
        }
    }
    
    func getNumberOfSections() -> Int {
        return arrayWithSections.count
    }
    
    func getNumberOfCellsIn(_ section: Int) -> Int {
        return arrayWithSections[section].getNumberOfItems()
    }
    
    func getTitleFor(_ section: Int) -> String {
        return arrayWithSections[section].title
    }
    
    func getSectionCellTitleFor(_ indexPath: IndexPath) -> String {
        return arrayWithSections[indexPath.section].arrayWithItems[indexPath.row].title
    }
    
    enum FilterType {
        case event
        case news
        case members
    }
}

extension FilterManager {
    struct FilterSection {
        let title: String
        let type: FilterSectionType
        let arrayWithItems: [FilterItem]!
        
        func getNumberOfItems() -> Int {
            return arrayWithItems.count
        }
        
        struct FilterItem {
            let title: String!
        }
        
        enum FilterSectionType {
            case date
            case category
            case sortArticles
            case sortPeople
            case starred
            case readingStatus
        }
        
    }
}

