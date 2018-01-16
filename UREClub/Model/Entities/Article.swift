//
//  Article.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 26.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import Foundation
import SwiftSoup

class Article: NSObject {
    var recordID: String
    var title: String
    var htmlContent: String
    var textContent: String
    var categories: [Category]
    let defaultImage: [UIImage] = [#imageLiteral(resourceName: "image-placeHolder")]
    var imageLinks: [String] {
        return parseImagesAndContentFromHTML()
    }
    
    func getHTMLContent() -> String {
        
        guard let path = Bundle.main.path(forResource: "ArticleStyles", ofType: "css") else { return "" }
        let cssString = try! String(contentsOfFile: path).trimmingCharacters(in: .whitespacesAndNewlines)
        let doc: Document = try! SwiftSoup.parse(htmlContent)
        try! doc.head()?.append("<style>\(cssString)</style>")
        
        return try! doc.html()
    }
    
    init(id: String, title: String, textContent: String, htmlContent: String, categories: [Category]) {
        
        self.recordID = id
        self.title = title
        self.htmlContent = htmlContent
        self.textContent = textContent
        self.categories = categories
    }
    
    convenience override init() {
        self.init(id: "0", title: "", textContent: "", htmlContent: "", categories: [Category]())
    }
    
    func parseImagesAndContentFromHTML() -> [String] {
        do {
            var arrayWithImageLinks = [String]()
            
            let doc: Document = try! SwiftSoup.parse(htmlContent)
            textContent = try doc.body()?.text() ?? ""
            
            let els: Elements = try SwiftSoup.parse(htmlContent).select("img")
            for link: Element in els.array(){
                let linkSrc: String = try link.attr("src")
                arrayWithImageLinks.append(linkSrc)
            }
            
            arrayWithImageLinks.uniqInPlace()
            
            return arrayWithImageLinks
        } catch {
            return [String]()
        }
    }
}
