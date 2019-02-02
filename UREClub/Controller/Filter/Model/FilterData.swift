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
                        Filter.FilterSectionItem(id: [2019], title: "2019"),
                        Filter.FilterSectionItem(id: [2018], title: "2018"),
                        Filter.FilterSectionItem(id: [2017], title: "2017"),
                        Filter.FilterSectionItem(id: [2016], title: "2016"),
                        Filter.FilterSectionItem(id: [2015], title: "2015"),
                    ]
                ),
                Filter.FilterSection(title: "filter_section_category".localized(), type: .category, selection: .multiple, arrayWithItems:
                    [
                        Filter.FilterSectionItem(id: [23,29,30], title: "filter_events_forums".localized()),
                        Filter.FilterSectionItem(id: [24,32,33], title: "filter_events_lunches".localized()),
                        Filter.FilterSectionItem(id: [25,38,39], title: "filter_events_committees".localized()),
                        Filter.FilterSectionItem(id: [26,36,37], title: "filter_events_international".localized()),
                        Filter.FilterSectionItem(id: [27,35,34], title: "filter_events_informal".localized())
                    ]
                )
            ]
        case .members:
            return [
                Filter.FilterSection(title: "filter_section_sortby".localized(), type: .sort, selection: .single, arrayWithItems:
                    [
                        Filter.FilterSectionItem(id: [0], title: "filter_members_az".localized()),
                        Filter.FilterSectionItem(id: [1], title: "filter_members_za".localized()),
                        Filter.FilterSectionItem(id: [2], title: "filter_members_joined_recently".localized())
                    ]
                ),
                Filter.FilterSection(title: "filter_section_category_user".localized(), type: .category, selection: .multiple, arrayWithItems:
                    [
                        Filter.FilterSectionItem(id: [44], title: "filter_members_architecture".localized()),
                        Filter.FilterSectionItem(id: [49], title: "filter_members_banking".localized()),
                        Filter.FilterSectionItem(id: [47], title: "filter_members_brokerage".localized()),
                        Filter.FilterSectionItem(id: [73], title: "filter_members_business_centre".localized()),
                        Filter.FilterSectionItem(id: [43], title: "filter_members_commercial".localized()),
                        Filter.FilterSectionItem(id: [45], title: "filter_members_consulting".localized()),
                        Filter.FilterSectionItem(id: [48], title: "filter_members_engineering".localized()),
                        Filter.FilterSectionItem(id: [50], title: "filter_members_funds_investment".localized()),
                        Filter.FilterSectionItem(id: [46], title: "filter_members_legal".localized()),
                        Filter.FilterSectionItem(id: [71], title: "filter_members_property_management".localized()),
                        Filter.FilterSectionItem(id: [42], title: "filter_members_residential".localized()),
                    ]
                )
            ]
        default:
            return [Filter.FilterSection]()
        }
    }
}
