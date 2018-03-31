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
    
    func getFilteredAndSortedArrayWithCompanies() -> [Company] {
        var arrayWithResult = [Company]()
        let searchString = contactsFilter.lowerCasedSearchString
        if contactsFilter.isInSearch {
            arrayWithResult = arrayWithCompanies.filter { company in
                let companyName = company.lowerCasedName
                let isNameOfCompanyMatch = companyName.contains(searchString)
                return isNameOfCompanyMatch
            }
        } else {
            arrayWithResult = arrayWithCompanies
        }
        return getSortedArrayWithCompanies(arrayWithResult)
    }
    
    func getSortedArrayWithCompanies(_ arrayWithCompanies: [Company]) -> [Company] {
        switch contactsFilter.type {
        case .members:
            return arrayWithCompanies.sorted { company1, company2 in
                switch contactsFilter.getSortingType() {
                case .az:
                    return company1.name < company2.name
                case .za:
                    return company1.name > company2.name
                case .recently:
                    return company1.getDateSince() > company2.getDateSince()
                }
            }
            
        default: return arrayWithCompanies
        }
    }
    
    var dictWithPersonsByCompanyID: [String: [Person]] {
        var result = [String: [Person]]()
        
        for company in arrayWithCompanies {
            let companyID = company.getStringWithID()
            let emptyArrayWithPerson = [Person]()
            result.updateValue(emptyArrayWithPerson, forKey: companyID)
        }
        
        for person in arrayWithPersons {
            let personsCompanyID = person.company.getStringWithID()
            result[personsCompanyID]?.append(person)
        }
        return result
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
            if company.getStringWithID() == searchingID {
                resultCompany = company
            }
        }
        return resultCompany
    }
    
    func getContactsData() {
        networkManager.retrieveInfoForPath(.contacts) { errors in
            DispatchQueue.main.async {
                // TODO: Handle errors here
            }
        }
    }
    
}

// MARK Array With Contacts
extension ContactsData {
    
    func getArrayWithContactsFor(types: [Contact.ContactType]) -> [GenericContact] {
        let filteredArrayWithContacts = arrayWithPersons.filter { person in types.contains(person.getContactType())}
        return getFilteredArrayWithPersons(filteredArrayWithContacts)
    }
    
    func getFilteredArrayWithPersons(_ arrayWithPersons: [Person]) -> [Person] {
        let personsFilteredWithSearch = filterWithSearch(arrayWithPersons)
        let personsFilteredWithAttendance = filterWithAttendanceList(personsFilteredWithSearch)
        let sortedPersons = sortPersons(personsFilteredWithAttendance)
        let result = getPersonsFilteredWithCategoryFrom(sortedPersons)
        return result
    }
    
    func sortPersons(_ arrayWithPersons: [Person]) -> [Person] {
        switch contactsFilter.type {
        case .members:
            return arrayWithPersons.sorted { person1, person2 in
                switch contactsFilter.getSortingType() {
                case .az:
                    return person1.fullName < person2.fullName
                case .za:
                    return person1.fullName > person2.fullName
                case .recently:
                    return person1.getDateSince() > person2.getDateSince()
                }
            }

        case .contacts:
            return arrayWithPersons.sorted { $0.getPriority() < $1.getPriority() }
            
        default: return arrayWithPersons
        }
    }
    
    func getPersonsFilteredWithCategoryFrom(_ sourceArrayWithPersons: [Person]) -> [Person] {
        return sourceArrayWithPersons.filter() { person in
            guard let chosenCategories = contactsFilter.chosenCategories, !chosenCategories.isEmpty else {
                return true
            }
            let doesEventMatchToSelectedCategories = chosenCategories.containsAnythingFrom(array: person.getArrayWithAllCategoriesIds())
            
            return doesEventMatchToSelectedCategories
        }
    }
    
    func filterWithSearch(_ arrayWithPersons: [Person]) -> [Person] {
        if contactsFilter.isInSearch {
            let searchString = contactsFilter.lowerCasedSearchString
            let filteredPersonsWithSearch = arrayWithPersons.filter { person in
                let firstName = person.firstName.lowercased()
                let lastName = person.lastName.lowercased()
                let isFirstNameMatch = firstName.contains(searchString)
                let isLastNameMatch = lastName.contains(searchString)
                let isPersonMatchWithSearch = isFirstNameMatch || isLastNameMatch
                return isPersonMatchWithSearch
            }
            return filteredPersonsWithSearch
        } else {
            return arrayWithPersons
        }
    }
    
    func filterWithAttendanceList(_ arrayWithPersons: [Person]) -> [Person] {
        if isItAttendanceScreen {
            let filteredPersonsWithAttendanceList = arrayWithPersons.filter { person in
                let personID = person.getID()
                let arrayWithAttendancePersons = getArrayWithAttendancePersons()
                let isIdOfPersonMathWithAttendanceList = arrayWithAttendancePersons.contains(personID)
                return isIdOfPersonMathWithAttendanceList
            }
            return filteredPersonsWithAttendanceList
        } else {
            return arrayWithPersons
        }
    }
}

// MARK: Attendance screen methods
extension ContactsData {
    
    var isItAttendanceScreen: Bool {
        guard let arrayWithIDsOfMembers = contactsFilter.contactsIDToPresentOnly else {
            return false
        }
        let isThereAnyMember = arrayWithIDsOfMembers.count > 0
        return isThereAnyMember
    }
    
    func setAttendanceParams(_ membersID: [Int]?) {
        contactsFilter.contactsIDToPresentOnly = membersID
    }
    
    func getArrayWithAttendancePersons() -> [Int] {
        return contactsFilter.contactsIDToPresentOnly ?? [Int]()
    }
}
