//
//  Category.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 15.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

struct Category {
    let id: String
    let name: String
    
    init(withResult resultDictionary: [String: Any]) {
        self.id = resultDictionary["id"] as? String ?? "0"
        self.name = resultDictionary["name"] as? String  ?? ""
    }
}
