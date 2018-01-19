//
//  CalendarCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 19.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class CalendarCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateCellWith(_ event: Event) {
        dayLabel.text = event.getDayFromDate()
        titleLabel.text = event.title
    }
    
}
