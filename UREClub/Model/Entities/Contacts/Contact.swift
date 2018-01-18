//
//  Member.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

protocol GenericContact {
    /// Returns generic cell for using in collections
    func getContact() -> Self
}

extension Contact: GenericContact {
    func getContact() -> Self {
        return self
    }
}

class Contact {
    
    //TODO: Implement Array With Categories
    var categories: [Category]!
    
    private let id: String
    private var imageLink: String
    private var phone: String
    private var email: String
    private let priority: String
    fileprivate let type: String
    
    init(id: String, imageLink: String, type: String, phone: String?, email: String?, priority: String?) {
        self.id = id
        self.imageLink = imageLink ?? ""
        self.phone = phone ?? ""
        self.email = email ?? ""
        self.priority = priority ?? "9"
        self.type = type
    }
    
    convenience init(id: String, imageLink: String, type: String) {
        self.init(id: id, imageLink: imageLink, type: type, phone: nil, email: nil, priority: nil)
    }
    
    enum ContactType {
        case Person
        case Company
        case Worker
        case Undefined
        
        static func getTypeForString(_ value: String) -> ContactType {
            switch value {
            case "company":
                return .Company
            case "member":
                return .Person
            case "worker":
                return .Worker
            default:
                return .Undefined
            }
        }
    }
}

extension Contact {
    
    func getID() -> String {
        return id
    }
    
    public func getImageLink() -> String {
        return imageLink
    }
    
    func getTypeForString() -> ContactType {
        let type = ContactType.getTypeForString(self.type)
        return type
    }
    
}
