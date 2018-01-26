//
//  NetworkManager.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import Alamofire

@objc protocol NetworkManagerDelegate {
    @objc optional func didLoad(arrayWithNews:[News])
    @objc optional func didLoad(arrayWithEvents:[Event])
    @objc optional func didLoad(dictWithContacts:[String: [AnyObject]])
}

class NetworkManager: NSObject {
    
    weak var delegate: NetworkManagerDelegate?
    
    private var arrayWithEvents: [Event]!
    private var arrayWithNews: [News]!
    private var arrayWithPlaces: [Location]!
    
    private var dictWithContacts: [String: [AnyObject]]!
    
    func retrieveInfoForPath(_ path: RequestAddress.ServerPath, completionHandler: @escaping (_ errorMessages: [NetworkError]?)->())  {
        
        //var errorMessages = [NetworkError]()
        var headers: HTTPHeaders!
        var parameters: Parameters!
        var url: URL!
        
        switch path {
        case .events:
            let requestData = EventsRequestData()
            headers = requestData.getHeaders()
            parameters = requestData.getParams()
            url = requestData.getURL()
        case .news:
            let requestData = NewsRequestData()
            headers = requestData.getHeaders()
            parameters = requestData.getParams()
            url = requestData.getURL()
        case .contacts:
            let requestData = ContactsRequestData()
            headers = requestData.getHeaders()
            parameters = requestData.getParams()
            url = requestData.getURL()
        case .nonce:
            break
        case .bookEvent:
            break
        case .filter:
            break
        default:
            let requestData = EventsRequestData()
            headers = requestData.getHeaders()
            parameters = requestData.getParams()
            url = requestData.getURL()
            print("Undefined RequestAddress.ServerPath")
        }
        
        Alamofire.request(url, method:.get, parameters:parameters, headers:headers).responseJSON { (response) in
                        
            if let errorMessages = self.parseResultDataWith(response, andPath: path) {
                completionHandler(errorMessages)
            } else {
                completionHandler(nil)
            }
            
        }
    }
    
    private func parseResultDataWith(_ response: DataResponse<Any>, andPath path: RequestAddress.ServerPath) -> [NetworkError]? {
        var errorMessages = [NetworkError]()
        
        switch path {
        case .events:
            parseEventsWith(response)
            return nil
        case .news:
            parseNewsWith(response)
            return nil
        case .contacts:
            parseContactsWith(response)
            return nil
        default:
            errorMessages.append(NetworkError.undefinedPath)
            return errorMessages
        }
    }
    
    class RequestData {
        let bearerToken = CurrentUser.authToken
        func getParams() -> Parameters {
            return [
                "Authorization": bearerToken
            ]
        }
    }
    
    struct RequestAddress {
        enum ServerPath {
            
            //TODO: Change Server!!!
            fileprivate var currentServer: Server { return .test }
            fileprivate var ureclubRestPath: String { return "wp-json/s4s_ureclub_rest/v1/" }
            
            case login
            case register
            case contacts
            case events
            case bookEvent
            case nonce // Secure phrase to submit the event
            case news
            case user
            case filter
            case attendance
            
            func address() -> String {
                var resultAddress = currentServer.rawValue
                switch self {
                case .login: resultAddress += "wp-json/jwt-auth/v1/token"
                case .register: resultAddress += ureclubRestPath + "register"
                case .contacts: resultAddress += ureclubRestPath + "contacts"
                case .events: resultAddress += ureclubRestPath + "events"
                case .bookEvent: resultAddress += ureclubRestPath + "book-event"
                case .nonce: resultAddress += ureclubRestPath + "nonce"
                case .news: resultAddress += ureclubRestPath + "news"
                case .user: resultAddress += ureclubRestPath + "user"
                case .filter: resultAddress += ureclubRestPath + "filter"
                case .attendance: resultAddress += ureclubRestPath + "attendance"
                }
                return resultAddress
            }
        }
        fileprivate enum Server: String {
            case production = ""
            case test = "http://urec.1gb.ua/"
        }
    }
    
    private func makeDictionaryFrom(_ response: DataResponse<Any>) -> Dictionary<String, Any> {
        guard let resourcesArray = response.result.value as? Dictionary<String, Any> else {
            return Dictionary<String, Any>()
        }
        return resourcesArray
    }
    
}

//MARK: Login
extension NetworkManager {
    
    func loginWith(_ userData: LoginRequestData, completionHandler: @escaping (_ errorMessages: [String]?)->()) {
        
        guard let url = userData.getURL() else { return }
        
        let parameters = userData.getParams()
        
        Alamofire.request(url, method:.post, parameters:parameters).responseJSON { (response) in
            
            if let errorMessages = self.parseLoginResultDataWith(response) {
                completionHandler(errorMessages)
            } else {
                completionHandler(nil)
            }
        }
        
    }
    
    struct LoginRequestData {
        private let pageAddress: String = RequestAddress.ServerPath.login.address()
        
        public let username: String
        public let password: String
        
        func getParams() -> Parameters {
            return [
                "username": username,
                "password": password
            ]
        }
        
        func getURL() -> URL? {
            var result = "\(pageAddress)"
            result = result.replacingOccurrences(of: " ", with: "%20")
            return URL(string: result)
        }
    }
    
    private func parseLoginResultDataWith(_ response: DataResponse<Any>) -> [String]? {
        
        let userDataDict = makeDictionaryFrom(response)
        
        CurrentUser.getFirstAndLastNameFromString(userDataDict["user_display_name"] as? String ?? "")
        
        CurrentUser.id = userDataDict["id"] as? String ?? ""
        CurrentUser.email = userDataDict["email"] as? String ?? ""
        CurrentUser.phone = userDataDict["phone"] as? String ?? ""
        CurrentUser.firstName = userDataDict["first_name"] as? String ?? ""
        CurrentUser.lastName = userDataDict["last_name"] as? String ?? ""
        CurrentUser.textContent = userDataDict["description"] as? String ?? ""
        CurrentUser.authToken = userDataDict["token"] as? String ?? ""
        CurrentUser.company.companyId = userDataDict["company_id"] as? String ?? ""
        CurrentUser.company.companyName = userDataDict["company_name"] as? String ?? ""
        CurrentUser.linkImage = userDataDict["image_link"] as? String ?? ""
        CurrentUser.company.position = userDataDict["job_position"] as? String ?? ""
        CurrentUser.linkedIn_link = userDataDict["linkedIn_link"] as? String ?? ""
        CurrentUser.facebook_link = userDataDict["facebook_link"] as? String ?? ""
        CurrentUser.isLoggedIn = true
        
        return nil
    }
}

//MARK: Register
extension NetworkManager {
    
    struct RegisterRequestData {
        
        private var currentPath: RequestAddress.ServerPath {
            return .login
        }
        private let pageAddress: String = RequestAddress.ServerPath.register.address()
        
        public let username: String
        public let password: String
        public let name: String
        public let phone: String
        
        func getParams() -> Parameters {
            return [
                "username": username,
                "password": password
            ]
        }
        
        func getURL() -> URL? {
            var result = "\(pageAddress)"
            result = result.replacingOccurrences(of: " ", with: "%20")
            return URL(string: result)
        }
    }
    
}

//MARK: Events
extension NetworkManager {
    
    private func parseEventsWith(_ response: DataResponse<Any>) {
        
        guard let arrayWithEventsResult = response.result.value as? [(Dictionary<String, Any>)]  else {
            return
        }
        
        arrayWithEvents = [Event]()
        for dictWithResult in arrayWithEventsResult {
            let event = Event(withResult: dictWithResult)
            arrayWithEvents.append(event)
        }
        
        delegate?.didLoad?(arrayWithEvents: arrayWithEvents)
        
    }
    
    struct EventsRequestData {
        
        private var currentPath: RequestAddress.ServerPath {
            return .events
        }
        private let pageAddress: String = RequestAddress.ServerPath.events.address()
        
        func getParams() -> Parameters {
            return [
                "lang": LanguageManager.shared.currentLanguage.getLanguageCodeForServer()
            ]
        }
        
        func getHeaders() -> HTTPHeaders {
            return [
                "Authorization": CurrentUser.getBearerToken()
            ]
        }
        
        func getURL() -> URL? {
            var result = "\(pageAddress)"
            result = result.replacingOccurrences(of: " ", with: "%20")
            return URL(string: result)
        }
    }
    
}

//MARK: News
extension NetworkManager {
    
    private func parseNewsWith(_ response: DataResponse<Any>) {
        
        guard let arrayWithNewsResult = response.result.value as? [(Dictionary<String, Any>)]  else {
            return
        }
        
        arrayWithNews = [News]()
        for dictWithResult in arrayWithNewsResult {
            let news = News(withResult: dictWithResult)
            arrayWithNews.append(news)
        }
        
        delegate?.didLoad?(arrayWithNews: arrayWithNews)
        
    }
    
    struct NewsRequestData {
        
        private var currentPath: RequestAddress.ServerPath {
            return .news
        }
        private let pageAddress: String = RequestAddress.ServerPath.news.address()
        
        func getParams() -> Parameters {
            return [
                "lang": LanguageManager.shared.currentLanguage.getLanguageCodeForServer()
            ]
        }
        
        func getHeaders() -> HTTPHeaders {
            return [
                "Authorization": CurrentUser.getBearerToken()
            ]
        }
        
        func getURL() -> URL? {
            var result = "\(pageAddress)"
            result = result.replacingOccurrences(of: " ", with: "%20")
            return URL(string: result)
        }
    }
    
}

//MARK: Contacts
extension NetworkManager {
    
    private func parseContactsWith(_ response: DataResponse<Any>) {

        guard let dictWithResponse = response.result.value as? (Dictionary<String, Any>)  else {
            return
        }
        
        guard let dictWithPersons = dictWithResponse["people"] as? [(Dictionary<String, Any>)]  else {
            return
        }
        
        guard let dictWithCompanies = dictWithResponse["companies"] as? [(Dictionary<String, Any>)]  else {
            return
        }
        
        var arrayWithPersons = [Person]()
        for dictWithItem in dictWithPersons {
            let person = Person(withResult: dictWithItem)
            arrayWithPersons.append(person)
        }
        
        var arrayWithCompanies = [Company]()
        for dictWithItem in dictWithCompanies {
            let company = Company(withResult: dictWithItem)
            arrayWithCompanies.append(company)
        }
        
        dictWithContacts = [String: [AnyObject]]()
        dictWithContacts.updateValue(arrayWithPersons, forKey: "people")
        dictWithContacts.updateValue(arrayWithCompanies, forKey: "companies")
        
        delegate?.didLoad?(dictWithContacts: dictWithContacts)
        
    }
    
    struct ContactsRequestData {
        
        private var currentPath: RequestAddress.ServerPath {
            return .contacts
        }
        private let pageAddress: String = RequestAddress.ServerPath.contacts.address()
        
        func getParams() -> Parameters {
            return [
                "lang": LanguageManager.shared.currentLanguage.getLanguageCodeForServer()
            ]
        }
        
        func getHeaders() -> HTTPHeaders {
            return [
                "Authorization": CurrentUser.getBearerToken()
            ]
        }
        
        func getURL() -> URL? {
            var result = "\(pageAddress)"
            result = result.replacingOccurrences(of: " ", with: "%20")
            return URL(string: result)
        }
    }
    
}

//MARK: Get nonce
extension NetworkManager {
    
    func getNonce(completionHandler: @escaping (_ nonce: String?, _ error: String?)->()) {
        
        let userData = NonceRequestData()
        guard let url = userData.getURL() else {
            completionHandler(nil, "Bad url")
            return
        }
        let parameters = userData.getParams()
        let headers = userData.getHeaders()
        
        Alamofire.request(url, method:.post, parameters:parameters, headers:headers).responseJSON { (response) in
            
            guard let dictWithResponse = response.result.value as? (Dictionary<String, Any>)  else {
                completionHandler(nil, "No value from response")
                return
            }
            guard let dictWithData = dictWithResponse["data"] as? (Dictionary<String, Any>)  else {
                completionHandler(nil, "No data from value of the response")
                return
            }
            
            guard let nonce = dictWithData["nonce"] as? String else {
                completionHandler(nil, "No nonce from data")
                return
            }
            completionHandler(nonce, nil)
        }
    }
    
    struct NonceRequestData {
        
        private var currentPath: RequestAddress.ServerPath { return .nonce }
        private let pageAddress: String = RequestAddress.ServerPath.nonce.address()
        private let bearerToken = CurrentUser.getBearerToken()
        
        func getParams() -> Parameters {
            return [
                "Authorization": bearerToken,
                "nonce_action": "booking_add"
            ]
        }
        
        func getHeaders() -> HTTPHeaders {
            return [
                "Authorization": bearerToken
            ]
        }
        
        func getURL() -> URL? {
            var result = "\(pageAddress)"
            result = result.replacingOccurrences(of: " ", with: "%20")
            return URL(string: result)
        }
    }
    
}

//MARK: Book Event
extension NetworkManager {
    
    func bookEvent(_ userData: BookEventRequestData, completionHandler: @escaping ()->()) {
        
        guard let url = userData.getURL() else { return }
        let parameters = userData.getParams()
        let headers = userData.getHeaders()
        
        Alamofire.request(url, method:.post, parameters:parameters, headers:headers).responseJSON { (response) in
            completionHandler()
        }
    }
    
    struct BookEventRequestData {
        
        let nonce: String
        let event_id: String
        let ticket_id: String
        let amount: Int
        let comment: String
        
        private var currentPath: RequestAddress.ServerPath { return .nonce }
        private let pageAddress: String = RequestAddress.ServerPath.nonce.address()
        private let bearerToken = CurrentUser.getBearerToken()
        
        func getParams() -> Parameters {
            return [
                "action": "booking_add",
                "_wpnonce": nonce,
                "event_id": event_id,
                "em_tickets[\(ticket_id)][spaces]": amount,
                "booking_comment": comment,
                "em_lang": "en_US",
                "lang": "en"
            ]
        }
        
        func getHeaders() -> HTTPHeaders {
            return [
                "Authorization": bearerToken
            ]
        }
        
        func getURL() -> URL? {
            var result = "\(pageAddress)"
            result = result.replacingOccurrences(of: " ", with: "%20")
            return URL(string: result)
        }
    }
    
}
