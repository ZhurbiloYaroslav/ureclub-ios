//
//  Member.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class Member {
    
    private let id: String
    private let type: String
    
    init(id: String, type: String) {
        self.id = id
        self.type = type
    }
    
    enum MemberType {
        case Person
        case Company
        case Undefined
        
        func getTypeForString(_ value: String) -> MemberType {
            switch value {
            case "company":
                return .Company
            case "member":
                return .Person
            default:
                return .Undefined
            }
        }
    }
}

extension Member {
    
    func getID() -> String {
        return id
    }
    
//    func getTypeForString() -> MemberType {
//        let type = MemberType.getTypeForString("compnay")
//        return type
//    }
    
}
