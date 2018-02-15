//
//  ResultData.swift
//  QuitSmokingTogether
//
//  Created by Yaroslav Zhurbilo on 07.02.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

typealias CompletionHandlerWithData = (_ data: ResultData) -> ()

enum ResultData {
    case withErrors([NetworkError])
    case withEvents([Event])
}
