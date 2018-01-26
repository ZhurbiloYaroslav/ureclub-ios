//
//  NewsDescVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 19.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SDWebImage

class NewsDescVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet var slideshow: ImageSlideshow!
    
    var currentNews: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultBackground()
        updateUIWithLocalizedText()
        setupImageSlider()
        updateUIWithValues()
    }
    
    func updateUIWithLocalizedText() {
        
        navigationItem.title = "screen_newsDescription_title".localized()
        
    }
    
    func updateUIWithValues() {
        guard let news = currentNews else { return }
        
        var arrayWithImages = [SDWebImageSource]()
        
        if news.imageLinks.count > 0 {
            for imageLink in news.imageLinks {
                arrayWithImages.append(SDWebImageSource(urlString: imageLink)!)
            }
            slideshow.setImageInputs(arrayWithImages)
        } else {
            let imagePlaceholder = [ImageSource(imageString: "image-placeHolder")!]
            slideshow.setImageInputs(imagePlaceholder)
        }
        
        titleLabel.text = news.title
        dateLabel.text = news.getDate()
        contentLabel.numberOfLines = 0
        contentLabel.text = news.textContent
        
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
