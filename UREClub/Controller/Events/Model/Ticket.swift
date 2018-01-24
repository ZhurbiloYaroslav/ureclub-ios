//
//  Ticket.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 24.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class Ticket {
    private let id: Int
    private let total: Int
    private let reserved: Int
    
    init(id: Int, total: Int, reserved: Int) {
        self.id = id
        self.total = total
        self.reserved = reserved
    }
    
    convenience init(id: Int) {
        self.init(id: id, total: 0, reserved: 0)
    }
    
    convenience init(withResult resultDictionary: [String: Any]) {
        let id = resultDictionary["id"] as? Int ?? 0
        self.init(id: id)
    }
}

extension Ticket {
    
    func getID() -> Int {
        return id
    }
    
    func getStringWithID() -> String {
        return String(describing: id)
    }
    
}
