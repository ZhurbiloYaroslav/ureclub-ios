//
//  SetDefaultData.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 28.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class DefaultDataManager {
    
    func setDefaultData() {
        CurrentUser.firstName = "Yaroslav"
        CurrentUser.lastName = "Zhurbilo"
        CurrentUser.phone = "+38 063 487 24 39"
        CurrentUser.email = "zhurbilo.yaroslav@gmail.com"
    }
}
