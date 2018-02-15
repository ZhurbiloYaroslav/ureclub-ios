//
//  NetworkError.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 28.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

enum NetworkError: String {
    
    case undefined = "Undefined Error"
    
    case undefinedPath = "Undefined path"
    case badURL = "Bad URL"
    case cantCreateDictionary = "Result data error"
    case noConnection = "Network Error, check your connection"
    case invalidResultData = "Data Error, check your data"
    case badData = "Bad Data"
    
    var description: String {
        return self.rawValue
    }
}
