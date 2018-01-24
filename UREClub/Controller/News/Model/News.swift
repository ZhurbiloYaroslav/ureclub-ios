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
    //var ids: [Int]
    private var date: String
    
    func getDate() -> String {
        return Formatter.getOnlyDateFrom(dateString: date)
    }
    
    init(id: Int, title: String, textContent: String, htmlContent: String, categories: [Category], date: String) {
        self.date = date
        
        super.init(id: id, title: title, textContent: textContent, htmlContent: htmlContent, categories: categories)
    }
    
    convenience init() {
        self.init(id: 0, title: "", textContent: "", htmlContent: "", categories: [Category](), date: "")
    }
    
    convenience init(withResult resultDictionary: [String: Any]) {
                
        let id = resultDictionary["id"] as? Int ?? 0
        let dateString = resultDictionary["date"] as? String ?? ""
        let title = resultDictionary["title"] as? String  ?? ""
        let htmlContent = resultDictionary["content"] as? String  ?? ""
        let textContent = htmlContent
        let arrayWithCategories = resultDictionary["categories"] as? [[String: Any]] ?? [[String: Any]]()
        
        var categories = [Category]()
        for dictWithCategory in arrayWithCategories {
            let newCategory = Category(withResult: dictWithCategory)
            categories.append(newCategory)
        }
        self.init(id: id, title: title, textContent: textContent, htmlContent: htmlContent, categories: categories, date: dateString)
    }
}

