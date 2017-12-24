//
//  EventCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateCellWith(_ event: Event) {
        eventImage.downloadedFrom(link: event.imageLinks[0])
        titleLabel.text = event.title
        dateLabel.text = event.date.getDate()
        timeLabel.text = event.date.getTimePeriod()
        addressLabel.text = event.place.getAddressAndCity()
    }
}
