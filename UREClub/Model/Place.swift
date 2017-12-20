//
//  Place.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

struct Place {
    
    let id: String
    let title: String
    let city: String
    let address: String
    
    init(id: String, title: String, city: String, address: String) {
        self.id = id
        self.title = title
        self.city = city
        self.address = address
    }
    
    init() {
        self.init(id: "1", title: "CEO Club House", city: "Kyiv", address: "Some address")
    }
    
    func getAddressAndCity() -> String {
        return title + ", " + city
    }
}
