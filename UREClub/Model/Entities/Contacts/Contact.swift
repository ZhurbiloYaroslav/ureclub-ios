//
//  Member.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class Contact: NSObject {
    
    // TODO: Implement Array With Categories
    var categories: [Category]!
    
    private let id: Int
    private var imageLink: String
    private var phone: String
    private var email: String
    private let priority: Int
    private let dateSince: String
    fileprivate let type: String
    
    init(id: Int, imageLink: String, type: String, phone: String?, email: String?, priority: Int?, dateSince: String?) {

        self.id = id
        self.imageLink = imageLink
        self.phone = phone ?? ""
        self.email = email ?? ""
        self.priority = priority ?? Constants.Contact.defaultPriority
        self.type = type
        self.dateSince = dateSince ?? ""
    }
    
    convenience init(id: Int, imageLink: String, type: String) {
        self.init(id: id, imageLink: imageLink, type: type, phone: nil, email: nil, priority: nil, dateSince: nil)
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
    
    public func getStringWithID() -> String {
        return String(describing: id) ?? "0"
    }
    
    public func getID() -> Int {
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
    
    public func getDateSince() -> Date {
        return Formatter.getDateFrom(dateSince)
    }
    
    public func getDateSince() -> String {
        let resultDate = Formatter.getSinceMonthsFromTodayFor(getDateSince())
        return String(describing: resultDate) + " months with UREClub"
    }
    
    func getContactType() -> ContactType {
        let type = ContactType.getTypeForString(self.type)
        return type
    }
    
}

protocol GenericContact {
    func getContact() -> Self
    func getPriority() -> Int
}

extension Contact: GenericContact {
    func getContact() -> Self {
        return self
    }
    func getPriority() -> Int {
        return priority
    }
}
