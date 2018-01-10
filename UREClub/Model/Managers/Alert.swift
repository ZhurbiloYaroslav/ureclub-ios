//
//  Alert.swift
//  Fiskas
//
//  Created by Yaroslav Zhurbilo on 11.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import Foundation

class Alert {
    
    func presentAlertWith(title: String, andMessages arrayWithMessages: [String], completionHandler: @escaping (UIAlertController)->()) {
        var message = ""
        for index in 0...(arrayWithMessages.count - 1) {
            message += arrayWithMessages[index]
            message += (index < (arrayWithMessages.count - 1)) ? "\n" : ""
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        completionHandler(alertController)
    }
    
    func presentAlertWith(messages arrayWithMessages: [String], completionHandler: @escaping (UIAlertController)->()) {
        presentAlertWith(title: "User login", andMessages: arrayWithMessages) { (alertController) in
            completionHandler(alertController)
        }
    }
    
}

