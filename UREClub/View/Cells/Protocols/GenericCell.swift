//
//  CustomCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 30.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

/**
 Needs to be used in collections
 */
protocol GenericCell {
    /// Returns generic cell for using in collections
    func getCell() -> Self
}

/**
 Needs to be used in collections
 */
protocol GenericCellData {
    /// Returns generic cell data for using in collections
    func getCellData() -> Self
}
