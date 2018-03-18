//
//  MembersManager.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class ContactsManager {
    
    public var contactsData = ContactsData.shared
    public var contactType: Contact.ContactType
    
    fileprivate var openedSection: Int?
    
    init(withFilterType filterType: Filter.FilterType, andType type: Contact.ContactType) {
        self.contactsData.contactsFilter = Filter(withType: filterType)
        self.contactType = type
    }
    
    // MARK: - Actions with Sections
    public func openSection(_ section: Int) {
        openedSection = section
    }
    
    public func closeSection(_ section: Int) {
        openedSection = nil
    }
    
    public func isOpened(_ section: Int) -> Bool {
        if let openedSection = openedSection {
            return openedSection == section
        }
        return false
    }
    
    // MARK: - Datasource methods
    public func getNumberOfSections() -> Int {
        switch contactType {
        case .company:
            return contactsData.getFilteredArrayWithCompanies().count
        default:
            return 1
        }
    }
    
    public func getNumberOfTableCellsFor(_ section: Int) -> Int {
        switch contactType {
        case .company:
            if isOpened(section) {
                return getNumberOfTableCellsThatContainsCompany(section)
            }
            return 0
            
        case .person:
            return contactsData.getArrayWithContactsFor(types: [self.contactType]).count
        case .worker:
            return contactsData.getArrayWithContactsFor(types: [self.contactType]).count
        case .undefined:
            return 0
        }
    }
    
    private func getNumberOfTableCellsThatContainsCompany(_ section: Int) -> Int {
        let companyID = getCompanyIdFor(section)
        let arrayWithPersons = getArrayWithPersonsFor(companyID)
        return arrayWithPersons.count
    }
    
    public func areThereMembersInCompanyWith(_ section: Int) -> Bool {
        return getNumberOfTableCellsThatContainsCompany(section) > 0
    }
    
    /*
    private func getNumberOfPersonCellsFor(_ section: Int) -> Int {
        if isOpened(section) {
            let company = getCompanyFor(section)
            let companyID = company.getStringWithID()
            if let dictWithPersonsOfCurrentCompany = contactsData.dictWithPersonsByCompanyID[companyID] {
                return dictWithPersonsOfCurrentCompany.count
            }
            return result
        } else {
            return 0
        }
    }
    */
    
    public func getPersonFor(_ indexPath: IndexPath) -> Person {
        switch contactType {
        case .company:
            let companyID = getCompanyIdFor(indexPath.section)
            let arrayWithPersons = getArrayWithPersonsFor(companyID)
            return arrayWithPersons[indexPath.row]
            
        case .person, .worker:
            guard let arrayWithContacts = contactsData.getArrayWithContactsFor(types: [contactType]) as? [Person] else {
                return Person()
            }
            return arrayWithContacts[indexPath.row]
        default:
            return getContactForCompanyTypeCell(indexPath) as? Person ?? Person()
        }
    }
    
    public func getCompanyFor(_ section: Int) -> Company {
        let filteredArrayWithCompanies = contactsData.getFilteredArrayWithCompanies()
        return filteredArrayWithCompanies[section]
    }
    
    // TODO: Figure out here!!!
    public func getContactForCompanyTypeCell(_ indexPath: IndexPath) -> Contact {
        var result = [Contact]()
        let arrayWithCompanies = contactsData.getFilteredArrayWithCompanies()
        
        if isOpened(indexPath.section) {
            
            for (index, company) in arrayWithCompanies.enumerated() {
                result.append(company)
                if let arrayWithPersons = contactsData.dictWithPersonsByCompanyID[company.getStringWithID()] {
                    for person in arrayWithPersons {
                        result.append(person)
                    }
                }
            }
            return result[indexPath.row]
            
        } else {
            return arrayWithCompanies[indexPath.row]
        }
    }
    
    public func getCompanyIdFor(_ section: Int) -> String {
        let company = getCompanyFor(section)
        return company.getStringWithID()
    }
    
    // MARK: - Datasource for Collection View
    public func getNumberOfCollectionCellsForTable(_ section: Int) -> Int {
        return getNumberOfTableCellsThatContainsCompany(section)
    }
    
    public func getPersonFor(collectionIndexPath: IndexPath, section: Int) -> Person {
        let personIndexInCollection = collectionIndexPath.row
        let personIndexPath = IndexPath(row: personIndexInCollection, section: section)
        let resultPerson = getPersonFor(personIndexPath)
        
        return resultPerson
    }
    
    public func getArrayWithPersonsFor(_ companyID: String) -> [Person] {
        var resultArrayWithPersons = [Person]()
        guard let arrayWithPersons = contactsData.getArrayWithContactsFor(types: [.person]) as? [Person]
            else { return [Person]() }
        for person in arrayWithPersons {
            if person.company.getStringWithID() == companyID {
                resultArrayWithPersons.append(person)
            }
        }
        return resultArrayWithPersons
    }
    
}
