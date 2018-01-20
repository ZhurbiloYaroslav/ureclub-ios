//
//  FilterManager.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class FilterManager {
    
    var currentFilter: GenericFilter!
    
    init(withFilter filter: GenericFilter) {
        self.currentFilter = filter.getFilter()
    }
    
    func getNumberOfSections() -> Int {
        return currentFilter.arrayWithSections.count
    }
    
    func getNumberOfCellsIn(_ section: Int) -> Int {
        return currentFilter.arrayWithSections[section].getNumberOfItems()
    }
    
    func getTitleFor(_ section: Int) -> String {
        return currentFilter.arrayWithSections[section].title
    }
    
    func getSectionCellTitleFor(_ indexPath: IndexPath) -> String {
        return currentFilter.arrayWithSections[indexPath.section].arrayWithItems[indexPath.row].title
    }
}

