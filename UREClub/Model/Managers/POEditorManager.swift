////
////  POEditorManager.swift
////  UREClub
////
////  Created by Yaroslav Zhurbilo on 28.12.17.
////  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
////
//
//import Foundation
//import Alamofire
//
//class POEditorManager {
//    // https://poeditor.com/api_reference/
//
//    private let headers: HTTPHeaders = HTTPHeaders()
//    private let apiAddress: URL? = URL(string: "https://poeditor.com/api/")
//    private let currentProject: Project
//
//    init(withProject project: Project) {
//        self.currentProject = project
//
//    }
//
//    public func getAppleStringsForLanguage(_ language: POLanguage) {
//        guard let url = apiAddress else { return }
//        let params = currentProject.getParamsFor(action: .Export, andLanguage: language)
//
//        Alamofire.request(url, method: .post, parameters: params, headers: headers).responseJSON { response in
//            guard let resourseMap = response.result.value as? Dictionary<String, Any> else { return }
//            guard let linkWithStrings = resourseMap["item"] as? String else { return }
//
//            self.downloadAppleStringsFileForLanguage(language, and: linkWithStrings)
//        }
//    }
//
//    private func downloadAppleStringsFileForLanguage(_ language: POLanguage, and address: String) {
//        let langCode = "Base"
//        let stringsFilePath = Bundle.main.path(forResource: "Localizable", ofType: "strings", inDirectory: nil, forLocalization: langCode)
//
//        someFunc(address)
//
//    }
//
//    func someFunc(_ address: String) {
//        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
//        let destinationFileUrl = documentsUrl.appendingPathComponent("downloadedFile.strings")
//
//        //Create URL to the source file you want to download
//        let fileURL = URL(string: address)
//
//        let sessionConfig = URLSessionConfiguration.default
//        let session = URLSession(configuration: sessionConfig)
//
//        let request = URLRequest(url:fileURL!)
//
//        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
//            if let tempLocalUrl = tempLocalUrl, error == nil {
//                // Success
//                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                    print("Successfully downloaded. Status code: \(statusCode)")
//                }
//
//                do {
//                    try FileManager.default.moveItem(at: tempLocalUrl, to: destinationFileUrl)
//                    let stringsFilePath = Bundle.main.path(forResource: "downloadedFile", ofType: "strings")
//                    print(tempLocalUrl)
//                } catch (let writeError) {
//                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
//                }
//
//            } else {
//                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
//            }
//        }
//        task.resume()
//    }
//
//    private func saveAppleStringsFileForLanguage(_ language: POLanguage) {
//
//    }
//
//    public struct Project {
//        let apiToken: String
//        let id: String
//
//        func getParamsFor(action: RequestAction, andLanguage language: POLanguage) -> Parameters {
//            var arrayWithParameters = Parameters()
//
//            arrayWithParameters.updateValue(apiToken, forKey: "api_token")
//            arrayWithParameters.updateValue(id, forKey: "id")
//
//            switch action {
//            case .Export:
//                arrayWithParameters.updateValue("apple_strings", forKey: "type")
//                arrayWithParameters.updateValue(action.rawValue, forKey: "action")
//                arrayWithParameters.updateValue(language.rawValue, forKey: "language")
//            }
//            return arrayWithParameters
//        }
//    }
//
//    public enum RequestAction: String {
//        case Export = "export"
//    }
//
//    public enum POLanguage: String {
//        case EN = "en-us"
//        case RU = "ru"
//        case UA = "uk"
//    }
//}

