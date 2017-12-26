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
    
    func parseResultDataWith(_ response: DataResponse<Any>, andPath path: RequestAddress.ServerPath) -> [NetworkError]? {
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
    
    func parseEventsWith(_ response: DataResponse<Any>) {
        
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
    
    func parseNewsWith(_ response: DataResponse<Any>) {
        
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
    
    struct RequestAddress {
        
        enum Server: String {
            case production = ""
            case test = "http://urec.1gb.ua/"
        }
        
        enum ServerPath: String {
            //case events_all = "wp-json/ee/v4.8.36/events?include=EVT_name,EVT_desc"
            case events_all = "wp-json/ee/v4.8.36/events"
            case news_all = "wp-json/wp/v2/posts"
            case users_all = "wp-json/wp/v2/users"
            case tags_all = "wp-json/wp/v2/tags"
            case categories_all = "wp-json/wp/v2/categories"
            
            func address() -> String {
                return Server.test.rawValue + self.rawValue
            }
        }
        
        let event = "https://jsonblob.com/api/jsonBlob/796b9a33-e587-11e7-ab8b-ffff88029e93"
        //event Page: https://jsonblob.com/796b9a33-e587-11e7-ab8b-ffff88029e93
        let place = "https://jsonblob.com/api/jsonBlob/1f72f941-e58c-11e7-ab8b-ff8f492747ba"
        //place Page: https://jsonblob.com/1f72f941-e58c-11e7-ab8b-ff8f492747ba
    }
    
    enum NetworkError: String {
        case undefinedPath = "Undefined path"
        case badURL = "Bad URL"
        case cantCreateDictionary = "Result data error"
        case noConnection = "Network Error, check your connection"
        case invalidResultData = "Data Error, check your data"
        case undefined = "Undefined Error"
    }
    
}

//MARK: Auth methods
extension NetworkManager {
    
    struct RegisterUserData {
        let pageAddress: String = "https://serwer1651270.home.pl/admin/api/register"
        let name: String
        let phone: String
        let email: String
        let password: String
        
        func getURL() -> URL? {
            var result = "\(pageAddress)"
            result += "?name=\(name)"
            result += "&phone=\(phone)"
            result += "&email=\(email)"
            result += "&pass=\(password)"
            result = result.replacingOccurrences(of: " ", with: "%20")
            return URL(string: result)
        }
    }
    
    struct LoginUserData {
        let pageAddress: String = "https://serwer1651270.home.pl/admin/api/login"
        let email: String
        let password: String
        
        func getURL() -> URL? {
            var result = "\(pageAddress)"
            result += "?email=\(email)"
            result += "&pass=\(password)"
            result = result.replacingOccurrences(of: " ", with: "%20")
            return URL(string: result)
        }
    }
}
