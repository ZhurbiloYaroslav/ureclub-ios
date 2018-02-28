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
                Filter.FilterSection(title: "filter_section_year".localized(), type: .year, selection: .single, arrayWithItems:
                    [
                        Filter.FilterSectionItem(id: [2018], title: "2018"),
                        Filter.FilterSectionItem(id: [2017], title: "2017"),
                        Filter.FilterSectionItem(id: [2016], title: "2016"),
                        Filter.FilterSectionItem(id: [2015], title: "2015")
                    ]
                ),
                Filter.FilterSection(title: "filter_section_category".localized(), type: .category, selection: .multiple, arrayWithItems:
                    [
                        Filter.FilterSectionItem(id: [23,29,30], title: "Forums/Conferences"),
                        Filter.FilterSectionItem(id: [24,32,33], title: "Business lunches"),
                        Filter.FilterSectionItem(id: [25,38,39], title: "Legal committees"),
                        Filter.FilterSectionItem(id: [26,36,37], title: "International events"),
                        Filter.FilterSectionItem(id: [27,35,34], title: "Informal")
                    ]
                )
            ]
        case .members:
            return [
                Filter.FilterSection(title: "filter_section_sortby".localized(), type: .sort, selection: .single, arrayWithItems:
                    [
                        Filter.FilterSectionItem(id: [0], title: "Recently joined"),
                        Filter.FilterSectionItem(id: [0], title: "A-Z"),
                        Filter.FilterSectionItem(id: [0], title: "Z-A")
                    ]
                ),
                Filter.FilterSection(title: "filter_section_category_user".localized(), type: .category, selection: .multiple, arrayWithItems:
                    [
                        Filter.FilterSectionItem(id: [42], title: "Residential"),
                        Filter.FilterSectionItem(id: [43], title: "Commercial"),
                        Filter.FilterSectionItem(id: [44], title: "Architecture"),
                        Filter.FilterSectionItem(id: [45], title: "Consulting"),
                        Filter.FilterSectionItem(id: [46], title: "Legal")
                    ]
                )
            ]
        default:
            return [Filter.FilterSection]()
        }
    }
}
