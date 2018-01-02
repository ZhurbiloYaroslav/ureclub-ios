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
    
    public var numberOfCells: Int {
        return mapWithCells.count
    }
    
    public func getNumberOfCellsInSection(_ section: Int) -> Int {
        guard let sectionEnum = TableSectionNumber(rawValue: section) else { return 0 }
        guard let numberOfCells = mapWithCells[sectionEnum]?.count else { return 0 }
        return numberOfCells
    }
    
    public func getCellDataForIndexPath(_ indexPath: IndexPath) -> GenericCellData? {
        guard let sectionEnum = TableSectionNumber(rawValue: indexPath.section) else { return nil }
        guard let genericCellData = mapWithCells[sectionEnum]?[indexPath.row] else { return nil }
        return genericCellData
    }
    
    /// Dictionary with Array of Cells Data
    private var mapWithCells: [TableSectionNumber: [GenericCellData]] = [
        .Section1 : [
            FieldCell.CellData(type: .NameFull,
                               icon: UIImage(),
                               title: "Full name:",
                               value: CurrentUser.fullName),
            FieldCell.CellData(type: .CompanyName,
                               icon: UIImage(),
                               title: "Company:",
                               value: CurrentUser.company.company.name),
            FieldCell.CellData(type: .UserPosition,
                               icon: UIImage(),
                               title: "Position:",
                               value: CurrentUser.company.position),
            FieldCell.CellData(type: .Email,
                               icon: UIImage(),
                               title: "Email:",
                               value: CurrentUser.email),
            FieldCell.CellData(type: .Phone,
                               icon: UIImage(),
                               title: "Mobile:",
                               value: CurrentUser.phone)
        ],
        .Section2 : [
            FieldCell.CellData(type: .LinkedIn,
                               icon: #imageLiteral(resourceName: "icon-facebook"),
                               title: "",
                               value: "LinkedIn"),
            FieldCell.CellData(type: .Facebook,
                               icon: #imageLiteral(resourceName: "icon-facebook"),
                               title: "",
                               value: "Facebook"),
            FieldCell.CellData(type: .Twitter,
                               icon: #imageLiteral(resourceName: "icon-facebook"),
                               title: "",
                               value: "Twitter")
        ],
        .Section3 : [
            FieldCell.CellData(type: .Text,
                               icon: UIImage(),
                               title: "",
                               value: "lorem_ipsum_text".localized())
        ],
        .Section4 : [
            FieldCell.CellData(type: .Password, icon: UIImage(), title: "Change password", value: "")
        ],
        .Section5 : [
            FieldCell.CellData(type: .UserPosition, icon: UIImage(), title: "", value: "English")
        ]
    ]
}
