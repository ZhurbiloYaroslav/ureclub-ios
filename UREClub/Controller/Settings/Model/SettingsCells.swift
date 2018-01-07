//
//  ProfileCells.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 30.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import Foundation

/// Struct that stores cells data
struct SettingsCells {
    
    public var numberOfSections: Int {
        return 2
    }
    
    public func getNumberOfCellsInSection(_ section: Int) -> Int {
        guard let sectionEnum = TableSectionNumber(rawValue: section) else { return 0 }
        switch sectionEnum {
        case .Section1:
            return 1
        case .Section2:
            return 1
        default:
            return 0
        }
    }
    
    public func getCellForTable(_ tableView: UITableView, andIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let sectionEnum = TableSectionNumber(rawValue: indexPath.section) else { return UITableViewCell() }
        switch sectionEnum {
        case .Section1:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChangePasswordCell", for: indexPath) as? ChangePasswordCell
                    else { return UITableViewCell() }
                return cell
            default:
                return UITableViewCell()
            }
        case .Section2:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeLanguageCell", for: indexPath) as? ChangeLanguageCell
                    else { return UITableViewCell() }
                return cell
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    /// Dictionary with Array of Cells Data
    private var mapWithCells: [TableSectionNumber: [GenericCellData]] = [
        .Section1 : [
            FieldCell.CellData(type: .NameFull,
                               icon: UIImage(),
                               title: "Full name:",
                               value: CurrentUser.fullName)
        ]
    ]
}
