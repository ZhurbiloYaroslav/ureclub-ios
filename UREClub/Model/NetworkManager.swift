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
    
    
    struct RequestAddress {
        let event = "https://jsonblob.com/api/jsonBlob/796b9a33-e587-11e7-ab8b-ffff88029e93"
        //event Page: https://jsonblob.com/796b9a33-e587-11e7-ab8b-ffff88029e93
        
        let place = "https://jsonblob.com/api/jsonBlob/1f72f941-e58c-11e7-ab8b-ff8f492747ba"
        //place Page: https://jsonblob.com/1f72f941-e58c-11e7-ab8b-ff8f492747ba

    }
    
}
