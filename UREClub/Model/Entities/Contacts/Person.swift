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
    
    convenience init(firstName: String, lastName: String, company: Company, position: String, dateSince: String,
                     id: Int, type: String, imageLink: String) {
        self.init(firstName: firstName, lastName: lastName, company: company, position: position, dateSince: dateSince,
                  id: id, type: type, imageLink: imageLink,
                  priority: nil, phone: nil, email: nil)
    }
    
    convenience init() {
        self.init(firstName: "", lastName: "", company: Company(), position: "", dateSince: "", id: 0, type: "", imageLink: "", priority: nil, phone: nil, email: nil)
    }
    
    init(firstName: String, lastName: String, company: Company, position: String, dateSince: String,
         id: Int, type: String, imageLink: String,
         priority: Int?, phone: String?, email: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.company = company
        self.position = position
        
        super.init(id: id, imageLink: imageLink, type: type, phone: phone, email: email, priority: priority, dateSince: dateSince)
        
    }
    
    convenience init(withResult resultDictionary: [String: Any]) {

        let id = resultDictionary["id"] as? Int ?? 0
        let type = resultDictionary["type"] as? String ?? ""
        let firstName = resultDictionary["firstName"] as? String ?? ""
        let lastName = resultDictionary["lastName"] as? String ?? ""
        let position = resultDictionary["position"] as? String ?? ""
        let dateSince = resultDictionary["dateSince"] as? String ?? ""
        let phone = resultDictionary["phone"] as? String ?? ""
        let email = resultDictionary["email"] as? String ?? ""
        let priority = resultDictionary["priority"] as? Int ?? 0
        
        let dictWithLinks = resultDictionary["links"] as? [String: Any]  ?? [String: Any]()
        let imageLink = dictWithLinks["image"] as? String ?? ""
        
        let dictWithCompany = resultDictionary["company"] as? [String: Any]  ?? [String: Any]()
        let companyID = dictWithCompany["id"] as? Int ?? 0
        let companyName = dictWithCompany["name"] as? String ?? ""
        let companyImage = "https://www.edukation.com.ua/upload_page/705/untitled_1_1453563195.jpg"
        let company = Company(name: companyName, id: companyID, type: "company", imageLink: companyImage)
        
        self.init(firstName: firstName, lastName: lastName, company: company, position: position, dateSince: dateSince,
                  id: id, type: type, imageLink: imageLink, priority: priority, phone: phone, email: email)
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
