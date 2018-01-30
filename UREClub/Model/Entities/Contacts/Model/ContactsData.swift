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
    
    func getContactsFromServer(completionHandler: @escaping (_ errorMessages: [NetworkError]?)->()) {
        networkManager.retrieveInfoForPath(.events) { (errors) in
            completionHandler(errors)
        }
    }
    
    init() {
        networkManager.delegate = self
        getContactsData()
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
        let filteredArrayWithContacts = arrayWithPersons.filter { person in types.contains(person.getContactType())}
        let sortedArrayWithContacts = filteredArrayWithContacts.sorted { $0.getPriority() < $1.getPriority() }
        for contact in sortedArrayWithContacts {
            print("---sorted", contact.getPriority(), " - ", contact.firstName)
        }
        return sortedArrayWithContacts
    }
    
    func getContactsData() {
        networkManager.retrieveInfoForPath(.contacts) { errors in

        }
    }
    
}









