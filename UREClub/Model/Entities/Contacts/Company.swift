//
//  Company.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 18.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class Company: Contact {
    var name: String
    
    convenience init(name: String, id: String, type: String, imageLink: String) {
        self.init(name: name, id: id, type: type, imageLink: imageLink,
                  priority: nil, phone: nil, email: nil)
    }
    
    init(name: String, id: String, type: String, imageLink: String,
         priority: String?, phone: String?, email: String?) {
        
        self.name = name
        super.init(id: id, imageLink: imageLink, type: type, phone: phone, email: email, priority: priority)
    }
}
