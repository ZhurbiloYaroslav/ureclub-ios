//
//  debugLog.swift
//  QuitSmokingTogether
//
//  Created by Yaroslav Zhurbilo on 03.02.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import UIKit

public func debugLog(_ message: String, file: String = #file, function: String = #function, line: Int = #line ) {
    print("\(message) called from \(function) \(file):\(line)")
}
