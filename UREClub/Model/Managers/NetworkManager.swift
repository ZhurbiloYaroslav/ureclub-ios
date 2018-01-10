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
}

class NetworkManager: NSObject {
    
    let headers: HTTPHeaders = HTTPHeaders()
    
    weak var delegate: NetworkManagerDelegate?
    
    private var arrayWithEvents: [Event]!
    private var arrayWithNews: [News]!
    private var arrayWithPlaces: [Place]!
    
    func retrieveInfoForPath(_ path: RequestAddress.ServerPath, completionHandler: @escaping (_ errorMessages: [NetworkError]?)->())  {
        
        var errorMessages = [NetworkError]()
        guard let url = URL(string: path.address()) else { return errorMessages.append(.badURL) }
        
        Alamofire.request(url).responseJSON { (response) in
            
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
        case .events_all:
            parseEventsWith(response)
            return nil
        case .news_all:
            parseNewsWith(response)
            return nil
        default:
            errorMessages.append(NetworkError.undefinedPath)
            return errorMessages
        }
    }
    
    struct RequestAddress {
        
        enum ServerPath: String {
            
            //TODO: Change Server!!!
            fileprivate var currentServer: Server {
                return .test
            }
            
            //case events_all = "wp-json/ee/v4.8.36/events?include=EVT_name,EVT_desc"
            case login = "wp-json/jwt-auth/v1/token"
            case register = "wp-json/s4s_ureclub_rest/v1/register"
            case events_all = "wp-json/s4s_ureclub_rest/v1/events"
            case news_all = "wp-json/s4s_ureclub_rest/v1/news"
            case user_info = "wp-json/s4s_ureclub_rest/v1/user"
            case tags_all = "wp-json/wp/v2/tags"
            case categories_all = "wp-json/wp/v2/categories"
            
            func address() -> String {
                return currentServer.rawValue + self.rawValue
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
        
        Alamofire.request(url, method:.post, parameters:parameters, headers:headers).responseJSON { (response) in
            
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

        print("response", response)
        let userDataDict = makeDictionaryFrom(response)
        print("userDataDict", userDataDict)
        
        CurrentUser.getFirstAndLastNameFromString(userDataDict["user_display_name"] as? String ?? "")
        
        CurrentUser.id = userDataDict["user_id"] as? String ?? ""
        CurrentUser.email = userDataDict["user_email"] as? String ?? ""
        CurrentUser.phone = userDataDict["user_phone"] as? String ?? ""
        CurrentUser.firstName = userDataDict["user_first_name"] as? String ?? ""
        CurrentUser.lastName = userDataDict["user_last_name"] as? String ?? ""
        CurrentUser.textContent = userDataDict["user_description"] as? String ?? ""
        CurrentUser.authToken = userDataDict["token"] as? String ?? ""
        CurrentUser.company.companyId = userDataDict["user_company_id"] as? String ?? ""
        CurrentUser.company.companyName = userDataDict["user_company_name"] as? String ?? ""
        CurrentUser.linkImage = userDataDict["user_link_image"] as? String ?? ""
        CurrentUser.company.position = userDataDict["user_job_position"] as? String ?? ""
        CurrentUser.linkedIn_link = userDataDict["user_linkedIn_link"] as? String ?? ""
        CurrentUser.facebook_link = userDataDict["user_facebook_link"] as? String ?? ""
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

//MARK: News
extension NetworkManager {
    
    private func parseNewsWith(_ response: DataResponse<Any>) {
        
        arrayWithNews = [News]()
        guard let arrayWithNewsResult = response.result.value as? [(Dictionary<String, Any>)]  else {
            return
        }
        
        for dictWithResult in arrayWithNewsResult {
            let news = News(withResult: dictWithResult)
            arrayWithNews.append(news)
        }
        
        delegate?.didLoad?(arrayWithNews: arrayWithNews)
        
    }
    
}

//MARK: Events
extension NetworkManager {
    
    private func parseEventsWith(_ response: DataResponse<Any>) {
        
        arrayWithEvents = [Event]()
        guard let arrayWithEventsResult = response.result.value as? [(Dictionary<String, Any>)]  else {
            return
        }
        
        for dictWithResult in arrayWithEventsResult {
            let event = Event(withResult: dictWithResult)
            arrayWithEvents.append(event)
        }
        
        delegate?.didLoad?(arrayWithEvents: arrayWithEvents)
        
    }
    
}
