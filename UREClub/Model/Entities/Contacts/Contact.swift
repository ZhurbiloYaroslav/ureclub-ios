//
//  Member.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class Contact: NSObject {
    
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
        self.imageLink = imageLink
        self.phone = phone ?? ""
        self.email = email ?? ""
        self.priority = priority ?? "9"
        self.type = type
    }
    
    convenience init(id: String, imageLink: String, type: String) {
        self.init(id: id, imageLink: imageLink, type: type, phone: nil, email: nil, priority: nil)
    }
    
    enum ContactType {
        case person
        case company
        case worker
        case undefined
        
        static func getTypeForString(_ value: String) -> ContactType {
            switch value {
            case "company":
                return .company
            case "member":
                return .person
            case "worker":
                return .worker
            default:
                return .undefined
            }
        }
    }
}

extension Contact {
    
    public func getID() -> String {
        return id
    }
    
    public func getEmail() -> String {
        return email
    }
    
    public func getPhone() -> String {
        return phone
    }
    
    public func getImageLink() -> String {
        return imageLink
    }
    
    func getContactType() -> ContactType {
        let type = ContactType.getTypeForString(self.type)
        return type
    }
    
}

protocol GenericContact {
    func getContact() -> Self
}

extension Contact: GenericContact {
    func getContact() -> Self {
        return self
    }
}
