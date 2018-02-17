//
//  String+isEqual.swift
//  Fiskas
//
//  Created by Yaroslav Zhurbilo on 11.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

extension String {
    func isEqualTo(_ find: String) -> Bool {
        return String(format: self) == find
    }
}
