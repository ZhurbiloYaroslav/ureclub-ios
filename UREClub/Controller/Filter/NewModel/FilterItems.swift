//
//  Items.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 26.02.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class FilterViewModelYearItem: FilterViewModelItem {
    var type: FilterViewModelItemType {
        return .year
    }
    var sectionTitle: String {
        return "Years"
    }
}

class FilterViewModelCategoryItem: FilterViewModelItem {
    var type: FilterViewModelItemType {
        return .category
    }
    var sectionTitle: String {
        return "Categories"
    }
}
