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
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var verticalLineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        verticalLineView.backgroundColor = UIColor(red:0.03, green:0.67, blue:0.96, alpha:1.0)
    }
    
    func updateCellWith(_ event: Event) {
        dayLabel.text = event.date.getDayFromDate()
        dayOfTheWeekLabel.text = event.date.getDayOfTheWeekFromDate()
        titleLabel.text = event.title
    }
    
}
