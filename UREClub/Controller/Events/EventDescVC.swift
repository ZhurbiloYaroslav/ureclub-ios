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
    }
    
    func updateUIWithValues() {
        guard let event = currentEvent else {
            return
        }
        
        eventImageView.downloadedFrom(link: event.imageLinks[0])
        eventTitleLabel.text = event.title
        eventDateLabel.text = event.date.getDate()
        eventTimePeriodLabel.text = event.date.getTimePeriod()
        eventAddressLabel.text = event.place.getAddressAndCity()
        eventContentLabel.text = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        
    }
    
}
