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
        super.awakeFromNib()
        
        setStyleForEvents()
    }
    
    func setStyleForEvents() {
        self.layer.borderWidth = 1
        self.layer.borderColor = Constants.Color.blueDark.cgColor
        self.backgroundColor = UIColor.clear
        self.tintColor = Constants.Color.blueDark
    }

}
