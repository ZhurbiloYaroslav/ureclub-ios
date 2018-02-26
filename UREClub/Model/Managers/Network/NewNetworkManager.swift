//
//  NewNetworkManager.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 18.02.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import Alamofire

extension NewNetworkManager {
    // MARK: Change it!
    static fileprivate var currentServer: Server {
        return .development
    }
    
    enum Server {
        case production, development
        
        var baseAddress: String {
            switch self {
            case .production: return ""
            case .development: return "http://urec.1gb.ua/"
            }
        }
    }
    
    static fileprivate var restPath: String {
        return "wp-json/s4s_ureclub_rest/v1/"
    }
}

class NewNetworkManager {
    
    func get(_ path: Request, completionHandler: @escaping CompletionHandlerWithData)  {
        
        var url: URL!
        var method: HTTPMethod!
        var headers: HTTPHeaders = HTTPHeaders()
        var parameters: Parameters = Parameters()
        
        switch path {
        case .attendance(let attendanceData):
            url = attendanceData.getURL()
            method = attendanceData.httpMethod
            headers = attendanceData.getHeaders()
            parameters = attendanceData.getParams()
        case .filter(let filterData):
            url = filterData.getURL()
            method = filterData.httpMethod
            headers = filterData.getHeaders()
            parameters = filterData.getParams()
        }
        Alamofire.request(url, method: method, parameters: parameters, headers: headers).responseJSON { response in
            
            let resultData = self.parseResultDataWith(response, andPath: path)
            completionHandler(resultData)
        }
    }
    
    func parseResultDataWith(_ response: DataResponse<Any>, andPath path: Request) -> ResultData {
        
        switch path {
        case .attendance:
            return getAttendanceFrom(response)
        case .filter:
            return getFilterFrom(response)
        default:
            let errorMessages = [NetworkError.undefinedPath]
            return ResultData.withErrors(errorMessages)
        }
    }
    
}

// MARK: Attendance
extension NewNetworkManager {
    
    func getAttendanceFrom(_ response: DataResponse<Any>) -> ResultData {
        
        let responseValue = makeDictionaryFrom(response)
        
        guard let dictWithData = responseValue["data"] as? Dictionary<String, Any> else {
            return ResultData.withErrors([NetworkError.badData])
        }
        
        guard let arrayWithMembersID = dictWithData["users"] as? [Int] else {
            return ResultData.withErrors([NetworkError.undefined])
        }
        
        return ResultData.withMembersID(arrayWithMembersID)
        
    }
    
    struct AttendanceData {
        public let eventID: Int
        public let httpMethod: HTTPMethod = .post
        private let requestAddress = restPath + "attendance"
        
        func getParams() -> Parameters {
            return [
                "event_id": eventID
            ]
        }
        
        func getHeaders() -> HTTPHeaders {
            return [
                "Authorization": CurrentUser.getBearerToken()
            ]
        }
        
        func getURL() -> URL? {
            let newURL = currentServer.baseAddress + requestAddress
            return URL(string: newURL)
        }
    }
}

// MARK: Filter
extension NewNetworkManager {
    
    func getFilterFrom(_ response: DataResponse<Any>) -> ResultData {
        
        let responseValue = makeDictionaryFrom(response)
        
        guard let dictWithData = responseValue["data"] as? Dictionary<String, Any> else {
            return ResultData.withErrors([NetworkError.badData])
        }
        
        return ResultData.dictWithFilter(dictWithData)
        
    }
    
    struct FilterData {
        public let httpMethod: HTTPMethod = .get
        private let requestAddress = restPath + "filter"
        
        func getParams() -> Parameters {
            return Parameters()
        }
        
        func getHeaders() -> HTTPHeaders {
            return [
                "Authorization": CurrentUser.getBearerToken()
            ]
        }
        
        func getURL() -> URL? {
            let newURL = currentServer.baseAddress + requestAddress
            return URL(string: newURL)
        }
    }
}

typealias CompletionHandlerWithData = (_ data: NewNetworkManager.ResultData) -> ()

extension NewNetworkManager {
    
    enum ResultData {
        case withErrors([NetworkError])
        case withMembersID([Int]) // Attendance
        case dictWithFilter([String: Any]) // Dictionary with Filter categories
    }
    
    enum Request {
        case attendance(AttendanceData)
        case filter(FilterData)
    }
    
}

// MARK: Helping methods
extension NewNetworkManager {
    
    private func makeDictionaryFrom(_ response: DataResponse<Any>) -> Dictionary<String, Any> {
        guard let resourcesArray = response.result.value as? Dictionary<String, Any> else {
            return Dictionary<String, Any>()
        }
        return resourcesArray
    }
}

//protocol RequestData {
//    var params: Parameters { get set }
//    var headers: HTTPHeaders { get set }
//}
//
//extension RequestData {
//
//    func addAuthorization() {
//        let bearerToken = CurrentUser.getBearerToken()
//        headers.updateValue(bearerToken, forKey: "Authorization")
//    }
//
//    func getParams() -> Parameters {
//        return params
//    }
//
//    func getHeaders() -> HTTPHeaders {
//        return headers
//    }
//}
