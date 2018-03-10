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
            
            // TODO: Change Server!!!
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
            case resetPassword
            case changePassword
            case photoUpdate
            
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
                case .changePassword: resultAddress += ureclubRestPath + "password-change"
                case .photoUpdate: resultAddress += ureclubRestPath + "photo-update"
                case .resetPassword: resultAddress += "s4s-reset-password.php"
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

// MARK: Login
extension NetworkManager {
    
    func loginWith(_ userData: LoginRequestData, completionHandler: @escaping (_ errorMessages: [String]?)->()) {
        
        guard let url = userData.getURL() else { return }
        
        let parameters = userData.getParams()
        
        Alamofire.request(url, method:.post, parameters:parameters).responseJSON { response in
            
            if response.result.error != nil {
                completionHandler(["server_bad_connection".localized()])
            } else if let errorMessages = self.parseLoginResultDataWith(response) {
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
        
        let dictWithResponse = makeDictionaryFrom(response)
        
        if let stringWithErrorCode = dictWithResponse["code"] as? String {
            switch stringWithErrorCode {
            case let codeValue where codeValue.contains("invalid_email"):
                return ["server_invalid_email".localized()]
            case let codeValue where codeValue.contains("incorrect_password"):
                return ["server_incorrect_password".localized()]
            default:
                return ["server_error_undefined".localized()]
            }
        }
        
        guard let userDataDict = dictWithResponse["data"] as? Dictionary<String, Any> else {
            return ["server_no_data".localized()]
        }

        CurrentUser.getFirstAndLastNameFromString(userDataDict["user_display_name"] as? String ?? "")

        CurrentUser.id = userDataDict["id"] as? Int ?? 0
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
        CurrentUser.linkedInLink = userDataDict["linkedIn_link"] as? String ?? ""
        CurrentUser.facebookLink = userDataDict["facebook_link"] as? String ?? ""
        CurrentUser.isLoggedIn = true
        
        return nil
    }
    
}

// MARK: Register
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

// MARK: Events
extension NetworkManager {
    
    private func parseEventsWith(_ response: DataResponse<Any>) {
        
//        guard let arrayWithEventsResult = response.result.value as? [(Dictionary<String, Any>)]  else {
//            return
//        }
        
        let dictWithResponse = makeDictionaryFrom(response)
        
        guard let arrayWithEventsResult = dictWithResponse["data"] as? [(Dictionary<String, Any>)] else {
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

// MARK: News
extension NetworkManager {
    
    private func parseNewsWith(_ response: DataResponse<Any>) {
        
//        guard let arrayWithNewsResult = response.result.value as? [(Dictionary<String, Any>)]  else {
//            return
//        }
        
        let dictWithResponse = makeDictionaryFrom(response)
        
        guard let arrayWithNewsResult = dictWithResponse["data"] as? [(Dictionary<String, Any>)] else {
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

// MARK: Contacts
extension NetworkManager {
    
    private func parseContactsWith(_ response: DataResponse<Any>) {
        
        let dictWithResponse = makeDictionaryFrom(response)
        
        guard let arrayWithNewsResult = dictWithResponse["data"] as? Dictionary<String, Any> else {
            return
        }
        
        guard let dictWithPersons = arrayWithNewsResult["people"] as? [(Dictionary<String, Any>)]  else {
            return
        }
        
        guard let dictWithCompanies = arrayWithNewsResult["companies"] as? [(Dictionary<String, Any>)]  else {
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

// MARK: Get nonce
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
            
            let dictWithResponse = self.makeDictionaryFrom(response)
            
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

// MARK: Book Event
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

// MARK: Reset Password
extension NetworkManager {
    
    func resetPassword(_ userData: ResetPasswordData, completionHandler: @escaping (_ errorMessages: [String]?)->()) {
        
        guard let url = userData.getURL() else { return }
        
        let parameters = userData.getParams()
        
        Alamofire.request(url, method:.post, parameters:parameters).responseJSON { response in
            
            if response.result.error != nil {
                completionHandler(["server_bad_connection".localized()])
            } else if let errorMessages = self.parseResetPasswordDataWith(response) {
                completionHandler(errorMessages)
            } else {
                completionHandler(nil)
            }
            
        }
        
    }
    
    struct ResetPasswordData {
        private let pageAddress: String = RequestAddress.ServerPath.resetPassword.address()
        
        public let email: String
        
        func getParams() -> Parameters {
            return [
                "email": email
            ]
        }
        
        func getURL() -> URL? {
            var result = "\(pageAddress)"
            result = result.replacingOccurrences(of: " ", with: "%20")
            return URL(string: result)
        }
    }
    
    private func parseResetPasswordDataWith(_ response: DataResponse<Any>) -> [String]? {
        
        let userDataDict = makeDictionaryFrom(response)
        
        let message = userDataDict["code"] as? String ?? "server_password_reset_success"
        return [message.localized()]
    }
    
}

// MARK: Change Password
extension NetworkManager {
    
    func changePassword(_ userData: ChangePasswordData, completionHandler: @escaping (_ errorMessages: [String]?)->()) {
        
        guard let url = userData.getURL() else { return }
        
        let parameters = userData.getParams()
        let headers = userData.getHeaders()
        
        Alamofire.request(url, method: .post, parameters: parameters, headers: headers).responseJSON { response in
            
            if response.result.error != nil {
                completionHandler(["server_bad_connection".localized()])
            } else if let errorMessages = self.parseChangePasswordDataWith(response) {
                completionHandler(errorMessages)
            } else {
                completionHandler(nil)
            }
            
        }
        
    }
    
    struct ChangePasswordData {
        private let pageAddress: String = RequestAddress.ServerPath.changePassword.address()
        private let bearerToken = CurrentUser.getBearerToken()
        
        public let newPassword: String
        
        func getParams() -> Parameters {
            return [
                "password": newPassword
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
    
    private func parseChangePasswordDataWith(_ response: DataResponse<Any>) -> [String]? {
        
        let userDataDict = makeDictionaryFrom(response)
        
        let message = userDataDict["code"] as? String ?? "undefined_error"
        return [message]
    }
    
}

//MARK: Photo
extension NetworkManager {
    
    func uploadPhoto(_ userData: UploadPhotoData, completionHandler: @escaping (_ errorMessages: [String]?)->()) {
        
        let image = userData.photoBody
        guard let imgData = UIImageJPEGRepresentation(image, 1) else { return }
        
        let parameters = userData.getHeaders()
        let fileName = "image-of-user-\(CurrentUser.getID()).jpg"
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "profile_image",fileName: fileName, mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to: userData.pageAddress, method:.post, headers: userData.getHeaders()) { result in
            switch result {
                
            case .success(let upload, _, _): // case .success(let upload, _, _):
                completionHandler(nil)
                 upload.responseJSON { response in
                     if let errorMessages = self.parseUploadPhotoDataWith(response) {
                         completionHandler(errorMessages)
                     } else {
                         completionHandler(nil)
                     }
             }
            case .failure(let encodingError):
                completionHandler([encodingError.localizedDescription])
            }
        }
    }
    
    private func parseUploadPhotoDataWith(_ response: DataResponse<Any>) -> [String]? {
        
        let userDataDict = makeDictionaryFrom(response)
        
        guard let data = userDataDict["data"] as? [String: Any] else {
            return ["no_data"]
        }
        guard let imageURL = data["imageURL"] as? String else {
            return ["no_image"]
        }
        CurrentUser.linkImage = imageURL
        return nil
    }
    
    struct UploadPhotoData {
        let pageAddress: String = RequestAddress.ServerPath.photoUpdate.address()
        let photoBody: UIImage
        
        func getParams() -> Parameters {
            return Parameters()
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
