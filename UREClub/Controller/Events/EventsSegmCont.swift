//
//  EventsSegmCont.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 19.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class EventsSegmCont: UISegmentedControl {
    
    override func awakeFromNib() {
        setStyleForEvents()
    }
    
    func setStyleForEvents() {
        self.borderWidth = 1
        self.borderColor = Constants.Color.skyDark
        self.backgroundColor = Constants.Color.skyDark
        self.tintColor = Constants.Color.skyDark
    }

}
