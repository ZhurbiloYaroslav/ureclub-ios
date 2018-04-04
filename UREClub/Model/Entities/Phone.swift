//
//  Phone.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 05.04.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

struct Phone {
    
    public var isHidden: Bool
    public var isEmpty: Bool {
        return getNumber().isEmpty
    }
    public var doesShow: Bool {
        return !isEmpty && !isHidden
    }
    
    private var number: String
    
    init(number: String?, isHidden: Bool?) {
        self.number = number ?? ""
        self.isHidden = isHidden ?? true
    }
    
    init(_ dictWithResult: [String: Any]) {
        let number = dictWithResult["main"] as? String
        let hide = dictWithResult["hide"] as? Bool
        self.init(number: number, isHidden: hide)
    }
    
    init() {
        self.init(number: nil, isHidden: nil)
    }
    
    public func getNumber() -> String {
        let charactersToRemove = [" ", "(", ")", "-", "_"]
        let trimmedPhone = number.stringByRemovingAll(subStrings: charactersToRemove)
        return trimmedPhone
    }
}
