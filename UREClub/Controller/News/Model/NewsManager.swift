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
        self.arrayWithNews = getSortedNewsFrom(arrayWithNews)
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
    
    func getSortedNewsFrom(_ newsArray: [News]) -> [News] {
        let newsSortedByDate = newsArray.sorted { news1, news2 in
            let news1Date = Formatter.getDateFrom(news1.getDate())
            let news2Date = Formatter.getDateFrom(news2.getDate())
            return news1Date < news2Date
        }
        return newsSortedByDate
    }
    
    func getArrayWithNews(completionHandler: @escaping (_ errorMessages: [NetworkError]?)->()) {
        networkManager.retrieveInfoForPath(.events) { (errors) in
            completionHandler(errors)
        }
    }
    
}
