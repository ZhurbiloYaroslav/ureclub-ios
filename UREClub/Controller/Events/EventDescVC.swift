//
//  EventDescVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class EventDescVC: UIViewController {
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimePeriodLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var eventContentLabel: UILabel!
    
    var currentEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultBackground()
        updateUIWithValues()
        updateUILabelsWithLocalizedText()
    }
    
    func updateUILabelsWithLocalizedText() {
        
        navigationItem.title = "screen_eventDescription_title".localized()
        
    }
    
    func updateUIWithValues() {
        guard let event = currentEvent else {
            return
        }
        if event.imageLinks.count > 0 {
            eventImageView.downloadedFrom(link: event.imageLinks[0])
        }
        
        eventTitleLabel.text = event.title
        eventDateLabel.text = event.date.getDate()
        eventTimePeriodLabel.text = event.date.getTimePeriod()
        eventAddressLabel.text = event.place.getAddressAndCity()
        eventContentLabel.text = event.textContent
        
    }
    
}
