//
//  FilterManager.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class FilterManager {
    
    var currentFilter: Filter!
    
    init(withType type: Filter.FilterType) {
        self.currentFilter = Filter(withType: type)
    }
    
    func getNumberOfSections() -> Int {
        return currentFilter.arrayWithSections.count
    }
    
    func getNumberOfCellsIn(_ section: Int) -> Int {
        return currentFilter.arrayWithSections[section].getNumberOfItems()
    }
    
    func getTitleFor(_ section: Int) -> String {
        return currentFilter.arrayWithSections[section].getTitle()
    }
    
    func getSectionCellTitleFor(_ indexPath: IndexPath) -> String {
        let arrayWithItems = currentFilter.arrayWithSections[indexPath.section].getArrayWithItems()
        return arrayWithItems[indexPath.row].title
    }
    
    func cellAccessoryTypeFor(_ indexPath: IndexPath) -> UITableViewCellAccessoryType {

        let parentSection = currentFilter.arrayWithSections[indexPath.section]
        let currentFilterItem = parentSection.getArrayWithItems()[indexPath.row]
        let filterType = parentSection.getFilterType()
        
        switch filterType {
        case .category:
            if let chosenCategories = currentFilter.chosenCategories, chosenCategories.contains(array: currentFilterItem.id) {
                return UITableViewCellAccessoryType.checkmark
            }
        case .year:
            if let chosenYear = currentFilter.chosenYear, currentFilterItem.id.contains(chosenYear) {
                return UITableViewCellAccessoryType.checkmark
            }
        default:
            debugLog("Was chosen undefined Filter Type")
        }
        
        return UITableViewCellAccessoryType.none
    }
    
    func wasPressedButtonWith(_ indexPath: IndexPath) {
        
        let parentSection = currentFilter.arrayWithSections[indexPath.section]
        let currentFilterItem = parentSection.getArrayWithItems()[indexPath.row]
        let filterType = parentSection.getFilterType()
        
        switch filterType {
        case .category:
            guard let chosenCategories = currentFilter.chosenCategories else {
                currentFilter.chosenCategories = currentFilterItem.id
                return
            }
            if chosenCategories.contains(array: currentFilterItem.id) {
                let categoriesWithoutCurrent = chosenCategories.filter { !currentFilterItem.id.contains($0) }
                currentFilter.chosenCategories = categoriesWithoutCurrent
            } else {
                currentFilter.chosenCategories?.append(contentsOf: currentFilterItem.id)
            }
            
        case .year:
            guard let chosenYear = currentFilter.chosenYear else {
                currentFilter.chosenYear = currentFilterItem.id[0]
                return
            }
            if currentFilterItem.id.contains(chosenYear) {
                currentFilter.chosenYear = nil
            } else {
                currentFilter.chosenYear = currentFilterItem.id[0]
            }
            
        default:
            debugLog("Was chosen undefined Filter Type")
        }
        
    }
}

