//
//  MembersManager.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class MembersManager {
    
    var arrayWithCompanies: [Company] {
        return [
            Company(name: "UREClub", id: "1", type: "company", imageLink: "https://www.edukation.com.ua/upload_page/705/untitled_1_1453563195.jpg"),
            Company(name: "Soft4Status", id: "2", type: "company", imageLink: "https://www.sunworldsoft.com/images/logo.png")
        ]
    }
    
    var arrayWithPersons: [Person] {
        return [
            Person(firstName: "Olga", lastName: "Solovei", company: getCompanyWithID("1"), position: "Director", dateSince: "01.01.2013",
                   id: "1", type: "member",
                   imageLink: "https://media.licdn.com/media/AAEAAQAAAAAAAAMIAAAAJDg3NzU5NjA5LWVmMmMtNDE1NC1hNzNhLTI2NzkzZTgyYjZlMA.jpg"),
            Person(firstName: "Dima", lastName: "Kuznets", company: getCompanyWithID("1"), position: "Head of Development", dateSince: "01.01.2014",
                   id: "2", type: "member",
                   imageLink: "https://media.licdn.com/media/AAEAAQAAAAAAAAqfAAAAJGY1ZTM4ODFkLTk5MWEtNDdkOS04YmNhLTUwMGU1NjlhMDk3Yw.jpg"),
            Person(firstName: "Dima", lastName: "Kuznets", company: getCompanyWithID("1"), position: "Head of Development", dateSince: "01.01.2014",
                   id: "3", type: "member",
                   imageLink: "https://media.licdn.com/media/AAEAAQAAAAAAAAqfAAAAJGY1ZTM4ODFkLTk5MWEtNDdkOS04YmNhLTUwMGU1NjlhMDk3Yw.jpg"),
            Person(firstName: "Dima", lastName: "Kuznets", company: getCompanyWithID("1"), position: "Head of Development", dateSince: "01.01.2014",
                   id: "4", type: "member",
                   imageLink: "https://media.licdn.com/media/AAEAAQAAAAAAAAqfAAAAJGY1ZTM4ODFkLTk5MWEtNDdkOS04YmNhLTUwMGU1NjlhMDk3Yw.jpg"),
            Person(firstName: "Dima", lastName: "Kuznets", company: getCompanyWithID("1"), position: "Head of Development", dateSince: "01.01.2014",
                   id: "5", type: "member",
                   imageLink: "https://media.licdn.com/media/AAEAAQAAAAAAAAqfAAAAJGY1ZTM4ODFkLTk5MWEtNDdkOS04YmNhLTUwMGU1NjlhMDk3Yw.jpg"),
            Person(firstName: "Dima", lastName: "Kuznets", company: getCompanyWithID("1"), position: "Head of Development", dateSince: "01.01.2014",
                   id: "6", type: "member",
                   imageLink: "https://media.licdn.com/media/AAEAAQAAAAAAAAqfAAAAJGY1ZTM4ODFkLTk5MWEtNDdkOS04YmNhLTUwMGU1NjlhMDk3Yw.jpg"),
            Person(firstName: "Yaroslav", lastName: "Zhurbilo", company: getCompanyWithID("2"), position: "iOS Developer", dateSince: "01.01.2017",
                   id: "7", type: "member",
                   imageLink: "https://media.licdn.com/mpr/mpr/shrinknp_400_400/p/4/005/0a6/0eb/23e5566.jpg"),
            Person(firstName: "Yaroslav", lastName: "Zhurbilo", company: getCompanyWithID("2"), position: "iOS Developer", dateSince: "01.01.2017",
                   id: "8", type: "member",
                   imageLink: "https://media.licdn.com/mpr/mpr/shrinknp_400_400/p/4/005/0a6/0eb/23e5566.jpg"),
            Person(firstName: "Yaroslav", lastName: "Zhurbilo", company: getCompanyWithID("2"), position: "iOS Developer", dateSince: "01.01.2017",
                   id: "9", type: "member",
                   imageLink: "https://media.licdn.com/mpr/mpr/shrinknp_400_400/p/4/005/0a6/0eb/23e5566.jpg"),
            Person(firstName: "Yaroslav", lastName: "Zhurbilo", company: getCompanyWithID("2"), position: "iOS Developer", dateSince: "01.01.2017",
                   id: "10", type: "member",
                   imageLink: "https://media.licdn.com/mpr/mpr/shrinknp_400_400/p/4/005/0a6/0eb/23e5566.jpg"),
            Person(firstName: "Yaroslav", lastName: "Zhurbilo", company: getCompanyWithID("2"), position: "iOS Developer", dateSince: "01.01.2017",
                   id: "11", type: "member",
                   imageLink: "https://media.licdn.com/mpr/mpr/shrinknp_400_400/p/4/005/0a6/0eb/23e5566.jpg"),
            Person(firstName: "Yaroslav", lastName: "Zhurbilo", company: getCompanyWithID("2"), position: "iOS Developer", dateSince: "01.01.2017",
                   id: "12", type: "member",
                   imageLink: "https://media.licdn.com/mpr/mpr/shrinknp_400_400/p/4/005/0a6/0eb/23e5566.jpg"),
            Person(firstName: "Vlad", lastName: "Kosmach", company: getCompanyWithID("2"), position: "Android Developer", dateSince: "01.01.2018",
                   id: "13", type: "member",
                   imageLink: "https://scontent.fiev4-1.fna.fbcdn.net/v/t1.0-0/p370x247/21616527_1651626758223582_903471387524966221_n.jpg?oh=0a936492c9a375415175476af8c81e98&oe=5AEADFA4")
        ]
    }
    
    func getCompanyWithID(_ searchingID: String) -> Company {
        var resultCompany = Company(name: "Undefined", id: "0", type: "company", imageLink: "")
        for company in arrayWithCompanies {
            if company.getID() == searchingID {
                resultCompany = company
            }
        }
        return resultCompany
    }
    
    func getNumberOfTableCellsFor(_ type: MemberType) -> Int {
        switch type {
        case .Company:
            return arrayWithCompanies.count
        case .Person:
            return arrayWithPersons.count
        }
    }
    
    func getNumberOfCollectionCellsForTable(_ tableIndexPath: IndexPath) -> Int {
        let companyID = getCompanyIdFor(tableIndexPath)
        let arrayWithPersons = getArrayWithPersonsFor(companyID)
        return arrayWithPersons.count
    }
    
    func getPersonFor(_ indexPath: IndexPath) -> Person {
        return arrayWithPersons[indexPath.row]
    }
    
    func getCompanyFor(_ indexPath: IndexPath) -> Company {
        return arrayWithCompanies[indexPath.row]
    }
    
    func getCompanyIdFor(_ indexPath: IndexPath) -> String {
        let company = getCompanyFor(indexPath)
        return company.getID()
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
        for person in arrayWithPersons {
            if person.company.getID() == companyID {
                resultArrayWithPersons.append(person)
            }
        }
        return resultArrayWithPersons
    }
    
    func getArrayWithContactsForType(_ type: MemberType) -> [GenericContact] {
        switch type {
        case .Company:
            return arrayWithCompanies
        case .Person:
            return arrayWithPersons
        }
    }
}

extension MembersManager {
    
    enum MemberType {
        case Company
        case Person
    }
    
}
