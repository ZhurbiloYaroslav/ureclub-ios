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
    
    var openedCellIndexPath: IndexPath?
    
    init(withFilterType filterType: Filter.FilterType, andType type: Contact.ContactType) {
        self.contactsData.contactsFilter = Filter(withType: filterType)
        self.contactType = type
    }
    
    func getNumberOfTableCells() -> Int {
        let type = self.contactType
        
        switch type {
        case .company:
            let amountOfCompanies = contactsData.getFilteredArrayWithCompanies().count
            let amountOfPersonsInOpenedCompanyCell = getAmountOfPersonsInOpenedCompanyCell()
            let sumOfCompaniesCellsAndOpenedPersonsCells = amountOfCompanies + amountOfPersonsInOpenedCompanyCell
            return sumOfCompaniesCellsAndOpenedPersonsCells
            
        case .person:
            return contactsData.getArrayWithContactsFor(types: [self.contactType]).count
        case .worker:
            return contactsData.getArrayWithContactsFor(types: [self.contactType]).count
        case .undefined:
            return 0
        }
    }
    
    func getAmountOfPersonsInOpenedCompanyCell() -> Int {
        var result = 0
        if let openedCellIndexPath = openedCellIndexPath {
            let company = getCompanyFor(openedCellIndexPath)
            let companyID = company.getStringWithID()
            if let dictWithPersonsOfCurrentCompany = contactsData.dictWithPersonsByCompanyID[companyID] {
                result = dictWithPersonsOfCurrentCompany.count
            }
            return result
        } else {
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
            return getContactForCompanyTypeCell(indexPath) as? Person ?? Person()
        }
    }
    
    func getCompanyFor(_ indexPath: IndexPath) -> Company {
        return contactsData.getFilteredArrayWithCompanies()[indexPath.row]
    }
    
    func getContactForCompanyTypeCell(_ indexPath: IndexPath) -> Contact {
        var result = [Contact]()
        let arrayWithCompanies = contactsData.getFilteredArrayWithCompanies()
        
        if let openedCellIndexPath = openedCellIndexPath {
            
            for (index, company) in arrayWithCompanies.enumerated() {
                result.append(company)
                if index == openedCellIndexPath.row {
                    if let arrayWithPersons = contactsData.dictWithPersonsByCompanyID[company.getStringWithID()] {
                        for person in arrayWithPersons {
                            result.append(person)
                        }
                    }
                    
                }
            }
            return result[indexPath.row]
            
        } else {
            return arrayWithCompanies[indexPath.row]
        }
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
