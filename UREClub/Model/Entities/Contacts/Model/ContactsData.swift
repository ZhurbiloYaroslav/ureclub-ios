//
//  ContactsData.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

extension ContactsData: NetworkManagerDelegate {
    
    func didLoad(dictWithContacts: [String : [AnyObject]]) {
        self.dictWithContacts = dictWithContacts
        self.delegate?.didReceiveContacts()
    }
}

protocol ContactsDataDelegate:class {
    func didReceiveContacts()
}

class ContactsData {
    
    weak var delegate: ContactsDataDelegate?
    
    static var shared = ContactsData()
    
    var dictWithContacts = [String : [AnyObject]]()
    
    var networkManager = NetworkManager()
    var contactsFilter: Filter!
    
    func getContactsFromServer(completionHandler: @escaping (_ errorMessages: [NetworkError]?)->()) {
        networkManager.retrieveInfoForPath(.events) { (errors) in
            completionHandler(errors)
        }
    }
    
    init() {
        networkManager.delegate = self
        getContactsData()
    }
    
    func getFilteredArrayWithCompanies() -> [Company] {
        var arrayWithResult = [Company]()
        let searchString = contactsFilter.lowerCasedSearchString
        if contactsFilter.isInSearch {
            arrayWithResult = arrayWithCompanies.filter { company in
                let companyName = company.lowerCasedName
                let isNameOfCompanyMatch = companyName.contains(searchString)
                print("---is?: ", isNameOfCompanyMatch, " ", companyName)
                return isNameOfCompanyMatch
            }
        } else {
            arrayWithResult = arrayWithCompanies
        }
        print("---result ", arrayWithResult)
        return arrayWithResult
    }
    
    var arrayWithCompanies: [Company] {
        if let resultArray = dictWithContacts["companies"] as? [Company] {
            return resultArray
        } else {
            return [Company]()
        }
    }
    
    var arrayWithPersons: [Person] {
        if let resultArray = dictWithContacts["people"] as? [Person] {
            return resultArray
        } else {
            return [Person]()
        }
    }
    
    func getCompanyWithID(_ searchingID: String) -> Company {
        var resultCompany = Company(name: "Undefined", id: 0, type: "company", imageLink: "")
        for company in arrayWithCompanies {
            if company.getID() == searchingID {
                resultCompany = company
            }
        }
        return resultCompany
    }
    
    func getArrayWithContactsFor(types: [Contact.ContactType]) -> [GenericContact] {
        var filteredArrayWithContacts = arrayWithPersons.filter { person in types.contains(person.getContactType())}
        switch types {
        case let person where person.contains(.person):
            filteredArrayWithContacts = getPersonsMathedSearching(filteredArrayWithContacts)
        default:
            break
        }
        let sortedArrayWithContacts = filteredArrayWithContacts.sorted { $0.getPriority() < $1.getPriority() }
        return sortedArrayWithContacts
    }
    
    func getPersonsMathedSearching(_ arrayWithPersons: [Person]) -> [Person] {
        var arrayWithResult = [Person]()
        let searchString = contactsFilter.lowerCasedSearchString
        if contactsFilter.isInSearch {
            arrayWithResult = arrayWithPersons.filter { person in
                let firstName = person.firstName.lowercased()
                let lastName = person.lastName.lowercased()
                let isFirstNameMatch = firstName.contains(searchString)
                let isLastNameMatch = lastName.contains(searchString)

                return isFirstNameMatch || isLastNameMatch
            }
        } else {
            arrayWithResult = arrayWithPersons
        }
        return arrayWithResult
    }
    
    func getContactsData() {
        networkManager.retrieveInfoForPath(.contacts) { errors in

        }
    }
    
}









