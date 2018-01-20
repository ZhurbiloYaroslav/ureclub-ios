//
//  NewsManager.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 19.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

extension NewsManager: NetworkManagerDelegate {
    func didLoad(arrayWithNews: [News]) {
        self.arrayWithNews = arrayWithNews
    }
}

class NewsManager {
    
    public static var shared = NewsManager()
    
    private var arrayWithNews = [News]()
    
    private var currentFilter = Filter(withType: .news)
    private var networkManager = NetworkManager()
    
    init() {
        networkManager.delegate = self
        getArrayWithNews { (errors) in }
    }
    
    func getNumberOfCells() -> Int {
        return arrayWithNews.count
    }
    
    func getNewsFor(_ indexPath: IndexPath) -> News {
        return arrayWithNews[indexPath.row]
    }
    
    func getArrayWithNews(completionHandler: @escaping (_ errorMessages: [NetworkError]?)->()) {
        networkManager.retrieveInfoForPath(.events) { (errors) in
            completionHandler(errors)
        }
    }
    
}
