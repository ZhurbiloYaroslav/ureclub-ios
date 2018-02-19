//
//  MembersManager.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class ContactsManager {
    
    var contactsData = ContactsData.shared
    
    var contactType: Contact.ContactType
    
    init(withFilterType filterType: Filter.FilterType, andType type: Contact.ContactType) {
        self.contactsData.contactsFilter = Filter(withType: filterType)
        self.contactType = type
    }
    
    func getNumberOfTableCells() -> Int {
        let type = self.contactType
        switch type {
        case .company:
            return contactsData.getFilteredArrayWithCompanies().count
        case .person:
            return contactsData.getArrayWithContactsFor(types: [self.contactType]).count
        case .worker:
            return contactsData.getArrayWithContactsFor(types: [self.contactType]).count
        case .undefined:
            return 0
        }
    }
    
    func getNumberOfCollectionCellsForTable(_ tableIndexPath: IndexPath) -> Int {
        let companyID = getCompanyIdFor(tableIndexPath)
        let arrayWithPersons = getArrayWithPersonsFor(companyID)
        return arrayWithPersons.count
    }
    
    func getPersonFor(_ indexPath: IndexPath) -> Person {
        switch contactType {
        case .person, .worker:
            guard let arrayWithContacts = contactsData.getArrayWithContactsFor(types: [contactType]) as? [Person] else {
                return Person()
            }
            return arrayWithContacts[indexPath.row]
        default:
            return Person()
        }
    }
    
    func getCompanyFor(_ indexPath: IndexPath) -> Company {
        return contactsData.getFilteredArrayWithCompanies()[indexPath.row]
    }
    
    func getCompanyIdFor(_ indexPath: IndexPath) -> String {
        let company = getCompanyFor(indexPath)
        return company.getStringWithID()
    }
    
    func getPersonFor(collectionIndexPath: IndexPath, tableIndexPath: IndexPath) -> Person {
        let companyID = getCompanyIdFor(tableIndexPath)
        let arrayWithPersons = getArrayWithPersonsFor(companyID)
        
        let personIndexInCollection = collectionIndexPath.row
        let resultPerson = arrayWithPersons[personIndexInCollection]
        
        return resultPerson
    }
    
    func getArrayWithPersonsFor(_ companyID: String) -> [Person] {
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
    
    func getArrayWithContactsForType() -> [GenericContact] {
        let type = self.contactType
        switch type {
        case .company:
            return contactsData.getFilteredArrayWithCompanies()
        case .person:
            return contactsData.getArrayWithContactsFor(types: [type])
        case .worker:
            return contactsData.getArrayWithContactsFor(types: [type])
        case .undefined:
            return [GenericContact]()
        }
    }
}
