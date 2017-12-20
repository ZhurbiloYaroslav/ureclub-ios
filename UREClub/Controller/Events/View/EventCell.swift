//
//  EventCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateCellWith(_ event: Event) {
        eventImageView.downloadedFrom(link: event.imageLinks[0])
        eventTitleLabel.text = event.title
        eventDateLabel.text = event.date.getDate()
        eventTimeLabel.text = event.date.getTimePeriod()
        eventAddressLabel.text = event.place.getAddressAndCity()
    }
}
