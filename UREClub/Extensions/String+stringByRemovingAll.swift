//
//  String+stringByRemovingAll.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 28.03.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

extension String {
    func stringByRemovingAll(characters: [Character]) -> String {
        return String(self.characters.filter({ !characters.contains($0) }))
    }
    
    func stringByRemovingAll(subStrings: [String]) -> String {
        var resultString = self
        subStrings.map { resultString = resultString.replacingOccurrences(of: $0, with: "") }
        return resultString
    }
}
