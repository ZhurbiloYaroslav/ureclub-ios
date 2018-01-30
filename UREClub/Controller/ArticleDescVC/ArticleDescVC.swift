//
//  EventDescVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SDWebImage

extension ArticleDescVC: StoryboardInitialized {}

class ArticleDescVC: UIViewController {
    
    // MARK: IBOutlets of Event and News
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentWebView: UIWebView!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: IBOutlets of Event only
    @IBOutlet weak var stackWithAddress: UIStackView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var stackWithTime: UIStackView!
    @IBOutlet weak var timePeriodLabel: UILabel!
    
    @IBOutlet weak var stackWithEventAttendance: UIStackView!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var attendanceListContainer: UIView!
    @IBOutlet weak var seeWhoAttendLabel: UILabel!
    
    @IBOutlet var slideshow: ImageSlideshow!
    
    var currentArticle: Article?
    
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultBackground()
        setDelegates()
        updateUIWithLocalizedText()
        setupImageSlider()
        setUIDependsOnEventOrNews()
        updateUIWithValues()
    }
    
    func setDelegates() {
        contentWebView.delegate = self
    }
    
    // MARK: IBAction(s)
    @IBAction func goButtonPressed(_ sender: UIButton) {
        guard let event = currentArticle as? Event else {
            return
        }
        networkManager.getNonce { (nonce, error) in
            guard let nonce = nonce else {
                return
            }
            let bookEventRequestData = NetworkManager.BookEventRequestData(
                nonce: nonce,
                event_id: event.getStringWithID(),
                ticket_id: event.ticket.getStringWithID(),
                amount: 1,
                comment: "All is ok"
            )
            self.networkManager.bookEvent(bookEventRequestData, completionHandler: {
                Alert().presentAlertWith(title: "Title", andMessages: ["Message"]) { alertVC in
                    self.present(alertVC, animated: true, completion: nil)
                }
            })
        }
    }
}

// MARK: Methods related with updating UI
extension ArticleDescVC {
    
    func setUIDependsOnEventOrNews() {
        switch currentArticle {
        case let eventArticle where eventArticle is Event:
            break
        case let newsArticle where newsArticle is News:
            stackWithAddress.isHidden = true
            stackWithTime.isHidden = true
            stackWithEventAttendance.isHidden = true
        default:
            break
        }
    }
    
    func updateUIWithLocalizedText() {
        
        switch currentArticle {
        case let eventArticle where eventArticle is Event:
            navigationItem.title = "screen_eventDescription_title".localized()
            seeWhoAttendLabel.text = "event_attend_seewho".localized()
        case let newsArticle where newsArticle is News:
            navigationItem.title = "screen_newsDescription_title".localized()
        default:
            break
        }
    }
    
    func updateUIWithValues() {
        guard let currentArticle = currentArticle else { return }
        
        setupSlideShowFor(currentArticle)
        
        titleLabel.text = currentArticle.title.uppercased()
        
        switch currentArticle {
            
        case let eventArticle as Event:
            
            addressLabel.text = eventArticle.location.getNameAndCity()
            dateLabel.text = eventArticle.date.getStringWithDate()
            timePeriodLabel.text = eventArticle.date.getTimePeriod()
            if eventArticle.isRegistrationDisabled() {
                goButton.isHidden = true
            }
            
        case let newsArticle as News:
            dateLabel.text = newsArticle.getDate()
            
        default:
            break
        }
        
        goButton.setRadius(5, withWidth: 1, andColor: UIColor.clear)
        attendanceListContainer.setRadius(5, withWidth: 2, andColor: #colorLiteral(red: 0, green: 0.631372549, blue: 0.8509803922, alpha: 1))
        
        contentWebView.loadHTMLString(currentArticle.getHTMLContent(), baseURL: Bundle.main.bundleURL)
        contentWebView.scrollView.isScrollEnabled = true
        contentWebView.scrollView.bounces = true
        contentWebView.backgroundColor = UIColor.clear
        contentWebView.sizeToFit()
    }
}

// Methods related to WebView
extension ArticleDescVC: UIWebViewDelegate {
    
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

// Slider
extension ArticleDescVC {
    
    func setupImageSlider() {
        slideshow.backgroundColor = UIColor.clear
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in }
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ArticleDescVC.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    func setupSlideShowFor(_ article: Article) {
        
        var arrayWithImages = [SDWebImageSource]()
        
        if article.imageLinks.count > 0 {
            for imageLink in article.imageLinks {
                arrayWithImages.append(SDWebImageSource(urlString: imageLink)!)
            }
            slideshow.setImageInputs(arrayWithImages)
        } else {
            let imagePlaceholder = [ImageSource(imageString: "image-placeHolder")!]
            slideshow.setImageInputs(imagePlaceholder)
        }
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        fullScreenController.closeButton.setImage(UIImage(named: "icon-close"), for: .normal)
        //fullScreenController.closeButton.setTitle("navbar_button_back".localized(), for: .normal)
    }
}
