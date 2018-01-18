//
//  Person.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 18.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class Person: Contact {
    var firstName: String
    var lastName: String
    var company: Company
    var position: String
    var dateSince: String
    
    convenience init(firstName: String, lastName: String, company: Company, position: String, dateSince: String,
                     id: String, type: String, imageLink: String) {
        self.init(firstName: firstName, lastName: lastName, company: company, position: position, dateSince: dateSince,
                  id: id, type: type, imageLink: imageLink,
                  priority: nil, phone: nil, email: nil)
    }
    
    init(firstName: String, lastName: String, company: Company, position: String, dateSince: String,
         id: String, type: String, imageLink: String,
         priority: String?, phone: String?, email: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.company = company
        self.position = position
        self.dateSince = dateSince
        
        super.init(id: id, imageLink: imageLink, type: type, phone: phone, email: email, priority: priority)
        
    }
    
    var fullName: String {
        var fullName = ""
        if firstName != "" {
            fullName = firstName
        }
        if firstName != "" && lastName != "" {
            fullName = fullName + " "
        }
        if lastName != "" {
            fullName = fullName + lastName
        }
        return fullName
    }
}
