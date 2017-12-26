//
//  News.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 23.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import SwiftSoup

class News: Article {
    var date: String
    
    init(id: Int, title: String, textContent: String, htmlContent: String, date: String) {
        self.date = date
        
        super.init(id: id, title: title, textContent: textContent, htmlContent: htmlContent)
    }
    
    convenience init() {
        self.init(id: 0, title: "", textContent: "", htmlContent: "", date: "")
    }
    
    convenience init(withResult resultDictionary: [String: Any]) {
        
        let renderedIitle = resultDictionary["title"] as? [String: Any] ?? [String: Any]()
        let title = renderedIitle["rendered"] as? String  ?? ""
        let renderedContent = resultDictionary["content"] as? [String: Any] ?? [String: Any]()
        let htmlContent = renderedContent["rendered"] as? String  ?? ""
        
        let id = resultDictionary["id"] as? Int ?? 0
        
        let textContent = htmlContent
        let newsDateString = resultDictionary["date"] as? String ?? ""
        
        self.init(id: id, title: title, textContent: textContent, htmlContent: htmlContent, date: newsDateString)
    }
}
