//
//  Member.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class Contact: NSObject {
    
    private let id: Int
    private var imageLink: String
    private var phone: Phone
    private var email: String
    private let priority: Int
    private let dateSince: String
    private let aboutText: String
    private let linkedInLink: String
    private let facebookLink: String
    private let categories: [Category]
    fileprivate let type: String
    
    init(id: Int, imageLink: String, type: String, aboutText: String, facebookLink: String, linkedInLink: String,
         categories: [Category], phone: Phone?, email: String?, priority: Int?, dateSince: String?) {

        self.id = id
        self.imageLink = imageLink
        self.phone = phone ?? Phone()
        self.email = email ?? ""
        self.categories = categories
        self.priority = priority ?? Constants.Contact.defaultPriority
        self.type = type
        self.dateSince = dateSince ?? ""
        self.aboutText = aboutText
        self.facebookLink = facebookLink
        self.linkedInLink = linkedInLink
    }
    
    convenience init(id: Int, imageLink: String, type: String, aboutText: String, facebookLink: String, linkedInLink: String) {
        self.init(id: id, imageLink: imageLink, type: type, aboutText: aboutText, facebookLink: facebookLink, linkedInLink: linkedInLink,
                  categories: [Category](), phone: nil, email: nil, priority: nil, dateSince: nil)
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
        return "\(id)"
    }
    
    public func getID() -> Int {
        return id
    }
    
    public func getEmail() -> String {
        return email
    }
    
    func getPhone() -> Phone {
        return phone
    }
    
    func getPhoneNumber() -> String {
        return phone.getNumber()
    }
    
    public func getImageLink() -> String {
        return imageLink
    }
    
    public func getDateSince() -> Date {
        return Formatter.getDateFrom(dateSince)
    }
    
    public func doesJoinedRecently() -> Bool {
        let calendar = NSCalendar.current
        let todayDate = calendar.startOfDay(for: Date())
        let sinceDate = calendar.startOfDay(for: getDateSince())
        let components = calendar.dateComponents([.day], from: todayDate, to: sinceDate)
        
        let daysIsMember = abs(components.day ?? 0)
        let maximudDaysThatAreRecently = 90
        return maximudDaysThatAreRecently > daysIsMember && daysIsMember > 0
    }
    
    public func getStringWithSincePeriod() -> String {
        let sinceComponent = Formatter.getSinceComponentFromTodayFor(getDateSince())
        let years = abs(sinceComponent.year ?? 0)
        let months = abs(sinceComponent.month ?? 0)
        var period = ""
        if years > 0 {
            var yearsString = ""
            switch years {
            case 1: yearsString = "year" // TODO: LCLZ
            default: yearsString = "years".localized()
            }
            period += "\(years) " + yearsString
        }
        if months > 0 {
            var monthsString = ""
            switch months {
            case 1: monthsString = "month" // TODO: LCLZ
            default: monthsString = "months".localized()
            }
            period += " \(months) " + monthsString
        }
        if period.isEmpty {
            return ""
        } else {
            return "\(period) with UREClub"
        }
    }
    
    func getContactType() -> ContactType {
        let type = ContactType.getTypeForString(self.type)
        return type
    }
    
    public func getTextContent() -> String {
        return aboutText
    }
    
    public func getFacebookLink() -> String {
        return facebookLink
    }
    
    public func getLinkedInLink() -> String {
        return linkedInLink
    }
    
    // MARK: - Check on Existing of Info
    
    public func facebookLinkIsEmpty() -> Bool {
        let doesFacebookLinkEmpty = facebookLink.trimmingCharacters(in: .whitespaces).isEmpty
        return doesFacebookLinkEmpty
    }
    
    public func linkedInkLinkIsEmpty() -> Bool {
        let doesLinkedInLinkEmpty = linkedInLink.trimmingCharacters(in: .whitespaces).isEmpty
        return doesLinkedInLinkEmpty
    }
    
    public func getArrayWithAllCategoriesIds() -> [Int] {
        var result = [Int]()
        categories.forEach { result.append($0.id) }
        return result
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
