//
//  FilterData.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

struct FilterData {
    
    func getArrayWithSectionsDependsOn(_ type: Filter.FilterType) -> [Filter.FilterSection] {
        switch type {
        case .events, .news:
            return [
                Filter.FilterSection(title: "Year", type: .year, arrayWithItems:
                    [
                        Filter.FilterSectionItem(title: "2018"),
                        Filter.FilterSectionItem(title: "2017"),
                        Filter.FilterSectionItem(title: "2016")
                    ]
                ),
                Filter.FilterSection(title: "Type", type: .category, arrayWithItems:
                    [
                        Filter.FilterSectionItem(title: "Forums/Conferences"),
                        Filter.FilterSectionItem(title: "Business lunches"),
                        Filter.FilterSectionItem(title: "Legal committees"),
                        Filter.FilterSectionItem(title: "International events"),
                        Filter.FilterSectionItem(title: "Informal")
                    ]
                ),
                Filter.FilterSection(title: "Sorting", type: .year, arrayWithItems:
                    [
                        Filter.FilterSectionItem(title: "Newer"),
                        Filter.FilterSectionItem(title: "Older")
                    ]
                ),
                Filter.FilterSection(title: "Status", type: .year, arrayWithItems:
                    [
                        Filter.FilterSectionItem(title: "All"),
                        Filter.FilterSectionItem(title: "Not read"),
                        Filter.FilterSectionItem(title: "Read")
                    ]
                ),
                Filter.FilterSection(title: "Starred", type: .year, arrayWithItems:
                    [
                        Filter.FilterSectionItem(title: "All"),
                        Filter.FilterSectionItem(title: "Starred"),
                        Filter.FilterSectionItem(title: "Not starred")
                    ]
                ),
            ]
        case .members:
            return [
                Filter.FilterSection(title: "Sort by", type: .year, arrayWithItems:
                    [
                        Filter.FilterSectionItem(title: "Recently joined"),
                        Filter.FilterSectionItem(title: "A-Z"),
                        Filter.FilterSectionItem(title: "Z-A")
                    ]
                ),
                Filter.FilterSection(title: "Occupation", type: .category, arrayWithItems:
                    [
                        Filter.FilterSectionItem(title: "Residential"),
                        Filter.FilterSectionItem(title: "Commercial"),
                        Filter.FilterSectionItem(title: "Architecture"),
                        Filter.FilterSectionItem(title: "Consulting"),
                        Filter.FilterSectionItem(title: "Legal")
                    ]
                )
            ]
        }
    }
}
