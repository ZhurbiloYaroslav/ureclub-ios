//
//  EventDescVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SDWebImage

class EventDescVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timePeriodLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet var slideshow: ImageSlideshow!
    
    var currentEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultBackground()
        updateUILabelsWithLocalizedText()
        setupImageSlider()
        updateUIWithValues()
    }
    
    func updateUILabelsWithLocalizedText() {
        
        navigationItem.title = "screen_eventDescription_title".localized()
        
    }
    
    func updateUIWithValues() {
        guard let event = currentEvent else { return }
        
        var arrayWithImages = [SDWebImageSource]()
        
        if event.imageLinks.count > 0 {
            for imageLink in event.imageLinks {
                arrayWithImages.append(SDWebImageSource(urlString: imageLink)!)
            }
            slideshow.setImageInputs(arrayWithImages)
        } else {
            let imagePlaceholder = [ImageSource(imageString: "image-placeHolder")!]
            slideshow.setImageInputs(imagePlaceholder)
        }
        
        titleLabel.text = event.title
        dateLabel.text = event.date.getDate()
        timePeriodLabel.text = event.date.getTimePeriod()
        addressLabel.text = event.place.getAddressAndCity()
        contentLabel.numberOfLines = 0
        contentLabel.text = event.textContent
    }
    
    func setupImageSlider() {
        
        slideshow.backgroundColor = UIColor.clear
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
            
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(NewsDescVC.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        fullScreenController.closeButton.setTitle("Go Back", for: .normal)
    }
    
}
