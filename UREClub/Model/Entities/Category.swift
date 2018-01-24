//
//  Category.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 15.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

struct Category {
    let id: Int
    let name: String
    
    init(withResult resultDictionary: [String: Any]) {
        self.id = resultDictionary["id"] as? Int ?? 0
        self.name = resultDictionary["name"] as? String  ?? ""
    }
}
