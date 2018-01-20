//
//  EventDescVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SDWebImage

extension EventDescVC: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
        webView.scrollView.isScrollEnabled = false
        webViewHeightConstraint.constant = webView.scrollView.contentSize.height
        webView.scalesPageToFit = true
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.url, navigationType == UIWebViewNavigationType.linkClicked {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            return false
        }
        return true
    }
}

class EventDescVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timePeriodLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    //@IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentWebView: UIWebView!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var slideshow: ImageSlideshow!
    
    var currentEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultBackground()
        setDelegates()
        updateUILabelsWithLocalizedText()
        setupImageSlider()
        updateUIWithValues()
    }
    
    func setDelegates() {
        contentWebView.delegate = self
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
        dateLabel.text = event.date.getStringWithDate()
        timePeriodLabel.text = event.date.getTimePeriod()
        addressLabel.text = event.place.getAddressAndCity()
                
        contentWebView.loadHTMLString(event.getHTMLContent(), baseURL: Bundle.main.bundleURL)
        contentWebView.scrollView.isScrollEnabled = true
        contentWebView.scrollView.bounces = true
        contentWebView.backgroundColor = UIColor.clear
        contentWebView.sizeToFit()
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
