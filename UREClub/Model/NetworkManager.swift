//
//  NetworkManager.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class NetrowkManager {
    
    private var arrayWithEvents: [Event]!
    private var arrayWithPlaces: [Place]!
    
    func getResult() {
        
    }
    
    func makeURLWithAddress(_ address: RequestAddress.ServerPath) -> URL? {
        guard let url = URL(string: address.address()) else {
            return nil
        }
        return url
    }
    
    struct RequestAddress {
        
        enum Server: String {
            case production = ""
            case test = "http://urec.1gb.ua/"
        }
        
        enum ServerPath: String {
            case events_all = "wp-json/ee/v4.8.36/events"
            case news_all = "wp-json/wp/v2/posts"
            case users_all = "wp-json/wp/v2/users"
            case tags_all = "wp-json/wp/v2/tags"
            case categories_all = "wp-json/wp/v2/categories"
            
            func address() -> String {
                return Server.test.rawValue + self.rawValue
            }
        }
        
        let event = "https://jsonblob.com/api/jsonBlob/796b9a33-e587-11e7-ab8b-ffff88029e93"
        //event Page: https://jsonblob.com/796b9a33-e587-11e7-ab8b-ffff88029e93
        let place = "https://jsonblob.com/api/jsonBlob/1f72f941-e58c-11e7-ab8b-ff8f492747ba"
        //place Page: https://jsonblob.com/1f72f941-e58c-11e7-ab8b-ff8f492747ba
    }
    
}
