//
//  EventCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SDWebImage

protocol EventCellDelegate: class {
    func didPressLocationOnCellWithEvent(_ event: Event)
}

class EventCell: UITableViewCell {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var timeStack: UIStackView!
    @IBOutlet weak var addressStack: UIStackView!
    @IBOutlet weak var geoImage: UIImageView!
    @IBOutlet weak var addressLabel: UIButton!
    
    weak var delegate: EventCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        articleImage.image = #imageLiteral(resourceName: "image-placeHolder")
    }
    
    public var event: Event! {
        didSet {
            titleLabel.numberOfLines = 3
            titleLabel.text = event.title
            
            if event.imageLinks.count > 0 {
                articleImage.sd_setImage(with: URL(string: event.imageLinks[0]), placeholderImage: #imageLiteral(resourceName: "image-placeHolder"))
            }
            
            dayLabel.text = event.date.getDayFromDate()
            monthLabel.text = event.date.getShirtStringWithMonthFromDate()
            timeLabel.text = event.date.getTimePeriod()
            addressLabel.setTitle(event.location.getNameAndCity(), for: .normal)
            addressLabel.setRadius(8, withWidth: 1, andColor: UIColor.clear)
        }
    }
    
    @IBAction func didPressLocationButton(_ sender: UIButton) {
        delegate?.didPressLocationOnCellWithEvent(event)
    }
}
