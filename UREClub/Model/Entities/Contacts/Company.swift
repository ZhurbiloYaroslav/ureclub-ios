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
    
    var lowerCasedName: String {
        return name.lowercased()
    }
    
    convenience init(name: String, id: Int, type: String, imageLink: String) {
        self.init(name: name, id: id, type: type, imageLink: imageLink,
                  priority: nil, phone: nil, email: nil, dateSince: nil)
    }
    
    convenience init() {
        self.init(name: "", id: 0, type: "", imageLink: "")
    }
    
    init(name: String, id: Int, type: String, imageLink: String,
         priority: Int?, phone: String?, email: String?, dateSince: String?) {
        
        self.name = name
        super.init(id: id, imageLink: imageLink, type: type, aboutText: "", facebookLink: "", linkedInLink: "",
                   phone: phone, email: email, priority: priority, dateSince: dateSince)
    }
    
    convenience init(withResult resultDictionary: [String: Any]) {
        
        let id = resultDictionary["id"] as? Int ?? 0
        let type = resultDictionary["type"] as? String ?? "company"
        let name = resultDictionary["name"] as? String ?? ""
        let phone = resultDictionary["phone"] as? String ?? ""
        let email = resultDictionary["email"] as? String ?? ""
        let priority = resultDictionary["priority"] as? Int ?? Constants.Contact.defaultPriority
        let dateSince = resultDictionary["dateSince"] as? String ?? ""
        
        let dictWithLinks = resultDictionary["links"] as? [String: Any]  ?? [String: Any]()
        let imageLink = dictWithLinks["image"] as? String ?? ""
        
        self.init(name: name, id: id, type: type, imageLink: imageLink, priority: priority, phone: phone, email: email, dateSince: dateSince)
    }
}
