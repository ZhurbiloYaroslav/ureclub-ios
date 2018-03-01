//
//  Array+contains.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 01.03.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    func contains(array: [Element]) -> Bool {
        for item in array {
            if !self.contains(item) { return false }
        }
        return true
    }
    
    func containsAnythingFrom(array: [Element]) -> Bool {
        for item in array {
            if self.contains(item) { return true }
        }
        return false
    }
}
