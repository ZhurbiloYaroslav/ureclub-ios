//
//  News.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 23.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import SwiftSoup

class News {
    var id: Int
    var title: String
    var htmlContent: String
    var description: String
    var imageLinks: [String]! {
        do{
            var arrayWithImageLinks = [String]()
            let doc: Document = try! SwiftSoup.parse(htmlContent)
            
            description = try! doc.body()?.text() ?? ""
            
            for link in try! doc.select("img").array() {
                arrayWithImageLinks.append(try! link.attr("src"))
            }
            arrayWithImageLinks.uniqInPlace()
            
            return arrayWithImageLinks
        }
    }
    
    init(id: Int, title: String, description: String, htmlContent: String) {
        self.id = id
        self.title = title
        self.htmlContent = htmlContent
        self.description = description
    }
    
    convenience init() {
        self.init(id: 0, title: "", description: "", htmlContent: "")
    }
    
    convenience init(withResult resultDictionary: [String: Any]) {
        
        let id = resultDictionary["id"] as? Int ?? 0
        let title = (resultDictionary["title"] as? [String: String] ?? ["rendered":""])["rendered"] ?? ""
        let htmlContent = (resultDictionary["content"] as? [String: String] ?? ["rendered":""])["rendered"] ?? ""
        let description = htmlContent
        
        self.init(id: id, title: title, description: description, htmlContent: htmlContent)
    }
}
