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
        return 3
    }
    
    public func getNumberOfCellsInSection(_ section: Int) -> Int {
        guard let sectionEnum = TableSectionNumber(rawValue: section) else { return 0 }
        switch sectionEnum {
        case .section1:
            return 1
        case .section2:
            return 1
        case .section3:
            return 1
        default:
            return 0
        }
    }
    
    public func getCellForTable(_ tableView: UITableView, andIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let sectionEnum = TableSectionNumber(rawValue: indexPath.section) else { return UITableViewCell() }
        switch sectionEnum {
        case .section1:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChangePasswordCell", for: indexPath) as? ChangePasswordCell
                    else { return UITableViewCell() }
                cell.updateCell()
                return cell
            default:
                return UITableViewCell()
            }
        case .section2:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeLanguageCell", for: indexPath) as? ChangeLanguageCell
                    else { return UITableViewCell() }
                cell.updateCell()
                return cell
            default:
                return UITableViewCell()
            }
        case .section3:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell", for: indexPath) as? AboutCell
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
        .section1: [
            FieldCell.CellData(type: .nameFull,
                               icon: UIImage(),
                               title: "Full name:",
                               value: CurrentUser.fullName)
        ]
    ]
}
