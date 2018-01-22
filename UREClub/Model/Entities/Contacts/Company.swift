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
    
    convenience init() {
        self.init(name: "", id: "", type: "", imageLink: "")
    }
    
    init(name: String, id: String, type: String, imageLink: String,
         priority: String?, phone: String?, email: String?) {
        
        self.name = name
        super.init(id: id, imageLink: imageLink, type: type, phone: phone, email: email, priority: priority)
    }
    
    convenience init(withResult resultDictionary: [String: Any]) {
        
        let id = resultDictionary["id"] as? String ?? "0"
        let type = resultDictionary["type"] as? String ?? ""
        let name = resultDictionary["name"] as? String ?? ""
        
        let dictWithLinks = resultDictionary["links"] as? [String: Any]  ?? [String: Any]()
        let imageLink = dictWithLinks["image"] as? String ?? ""
        
        //let dateSince = resultDictionary["dateSince"] as? String ?? ""
        //let phone = resultDictionary["phone"] as? String ?? ""
        //let email = resultDictionary["email"] as? String ?? ""
        
        self.init(name: name, id: id, type: type, imageLink: imageLink)
    }
}
