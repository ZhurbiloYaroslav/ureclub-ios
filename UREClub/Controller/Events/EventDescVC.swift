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
    @IBOutlet weak var contentWebView: UIWebView!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: IBOutlets of Event only
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var stackWithEventAttendance: UIStackView!
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var seeWhoAttendLabel: UILabel!
    
    @IBOutlet var slideshow: ImageSlideshow!
    
    var currentEvent: Event?
    
    let networkManager = NetworkManager()
    
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
        seeWhoAttendLabel.text = "event_attend_seewho".localized()
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
        addressLabel.text = event.location.getNameAndCity()
        
        if event.isRegistrationDisabled() {
            goButton.isHidden = true
        }
                
        contentWebView.loadHTMLString(event.getHTMLContent(), baseURL: Bundle.main.bundleURL)
        contentWebView.scrollView.isScrollEnabled = true
        contentWebView.scrollView.bounces = true
        contentWebView.backgroundColor = UIColor.clear
        contentWebView.sizeToFit()
    }
    
    //MARK: IBAction(s)
    @IBAction func goButtonPressed(_ sender: UIButton) {
        guard let event = currentEvent else {
            return
        }
        networkManager.getNonce { (nonce, error) in
            guard let nonce = nonce else {
                print(error)
                return
            }
            let bookEventRequestData = NetworkManager.BookEventRequestData(
                nonce: nonce,
                event_id: event.getStringWithID(),
                ticket_id: event.ticket.getStringWithID(),
                amount: 1,
                comment: "All ok"
            )
            self.networkManager.bookEvent(bookEventRequestData, completionHandler: {
                Alert().presentAlertWith(title: "Title", andMessages: ["Message"]) { alertVC in
                    self.present(alertVC, animated: true, completion: nil)
                }
            })
        }
    }
}

// Slider
extension EventDescVC {
    func setupImageSlider() {
        slideshow.backgroundColor = UIColor.clear
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in }
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(NewsDescVC.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        fullScreenController.closeButton.setTitle("navbar_button_back".localized(), for: .normal)
    }
}
