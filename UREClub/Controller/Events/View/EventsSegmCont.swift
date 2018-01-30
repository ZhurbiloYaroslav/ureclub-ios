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
        
        tintColor = Constants.Color.blueDark
        
        layer.cornerRadius = 0.0
        layer.borderWidth = 1.5
        layer.borderColor = Constants.Color.blueDark.cgColor
        layer.backgroundColor = Constants.DefaultColor.background.cgColor
        layer.masksToBounds = true
    }

}
