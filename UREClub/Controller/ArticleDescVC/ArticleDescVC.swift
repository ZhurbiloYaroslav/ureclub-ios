//
//  EventDescVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleDescVC: UIViewController {
    
    // MARK: IBOutlets of Event and News
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentWebView: UIWebView!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: IBOutlets of Event only
    @IBOutlet weak var stackWithAddress: UIStackView!
    @IBOutlet weak var addresButton: UIButton!
    
    @IBOutlet weak var stackWithTime: UIStackView!
    @IBOutlet weak var timePeriodLabel: UILabel!
    
    @IBOutlet weak var stackWithEventAttendance: UIStackView!
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var attendanceListContainer: UIView!
    @IBOutlet weak var seeWhoAttendButton: UIButton!
    
    @IBOutlet var slideshow: ImageSlideshow!
    
    var currentArticle: Article?
    
    let networkManager = NetworkManager()
    
    var attendanceData: [[String: Any]]?
    
    var currentUserBookingIdOnCurrentEvent: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAttendance()
        self.setDefaultBackground()
        setDelegates()
        updateUIWithLocalizedText()
        setupImageSlider()
        setupUI()
        setUIDependsOnEventOrNews()
        updateUIWithValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setDefaultStyle()
    }
    
    func setDelegates() {
        contentWebView.delegate = self
    }
    
    // MARK: - IBAction(s)
    @IBAction func goButtonPressed(_ sender: UIButton) {
        guard let event = currentArticle as? Event else { return }
        if let bookingID = currentUserBookingIdOnCurrentEvent {
            cancelBookingFor(bookingID)
        } else {
            performBookingFor(event)
        }
    }
    
    @IBAction func seeWhoAttendButtonPressed(_ sender: UIButton) {
        if let membersVC = MembersVC.getInstance(), let attendanceData = attendanceData {
            
            var membersID = [Int]()
            attendanceData.forEach { dictWithPersonAttendance in
                guard let personID = dictWithPersonAttendance["person"] as? Int
                    else { return }
                membersID.append(personID)
            }
            membersVC.contactsManager.contactsData.setAttendanceParams(membersID)
            navigationController?.pushViewController(membersVC, animated: true)
        }
    }
    
    @IBAction func addressButtonPressed(_ sender: UIButton) {
        guard let currentEvent = currentArticle as? Event else { return }
        let eventLocationLink = currentEvent.location.getGoogleMapsLink()
        Browser.openURLWith(eventLocationLink)
    }
    
}

// MARK: - Booking and Decline attendance
extension ArticleDescVC {
    
    func performBookingFor(_ event: Event) {
        let declineAttendanceData = NetworkManager.NonceRequestData(nonceAction: .bookingAdd)
        networkManager.getNonceWith(declineAttendanceData) { (nonce, error) in
            guard let nonce = nonce else {
                return
            }
            let bookEventRequestData = NetworkManager.BookEventRequestData(
                nonce: nonce,
                event_id: event.getStringWithID(),
                ticket_id: event.ticket.getStringWithID(),
                amount: 1,
                comment: ""
            )
            self.networkManager.bookEvent(bookEventRequestData, completionHandler: {
                self.getAttendance()
                let alertTitle = "alert_booking_success_title".localized()
                let alertMessage = ["alert_booking_success_message".localized()]
                Alert().presentAlertWith(title: alertTitle, andMessages: alertMessage) { alertVC in
                    self.present(alertVC, animated: true, completion: nil)
                }
            })
        }
    }
    
    func cancelBookingFor(_ bookingID: Int) {
        let declineAttendanceData = NetworkManager.NonceRequestData(nonceAction: .bookingCancel)
        networkManager.getNonceWith(declineAttendanceData) { (nonce, error) in
            guard let nonce = nonce else {
                return
            }
            let declineAttendanceData = NetworkManager.CancelBookingData(nonceAction: .bookingCancel, nonce: nonce, bookingID: bookingID)
            self.networkManager.declineAttendance(declineAttendanceData) {
                self.resetGoButtonStyle()
                self.getAttendance()
                let alertTitle = "alert_booking_decline_title".localized()
                let alertMessage = ["alert_booking_decline_message".localized()]
                Alert().presentAlertWith(title: alertTitle, andMessages: alertMessage) { alertVC in
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func resetGoButtonStyle() {
        self.goButton.setTitle("button_go_to_meeting".localized(), for: .normal)
        self.goButton.setBackgroundColor(color: #colorLiteral(red: 0, green: 0.631372549, blue: 0.8509803922, alpha: 1), forState: .normal)
        currentUserBookingIdOnCurrentEvent = nil
    }
    
}

// MARK: - Methods related with updating UI
extension ArticleDescVC {
    
    func setupUI() {
        goButton.isEnabled = false
    }
    
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
        
        //navigationItem.title = " ".localized()
        
        switch currentArticle {
        case let eventArticle where eventArticle is Event:
            goButton.setTitle("button_go_to_meeting".localized(), for: .normal)
            seeWhoAttendButton.setTitle("event_attend_seewho".localized(), for: .normal)
        case let newsArticle where newsArticle is News:
            break
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
            
            addresButton.setTitle(eventArticle.location.getNameAndCity(), for: .normal)
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
        
        addresButton.setRadius(5, withWidth: 1, andColor: UIColor.clear)
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

extension ArticleDescVC {
    
    func getAttendance() {
        self.goButton.isEnabled = false
        guard let event = currentArticle as? Event else { return }
        
        let attendanceData = NewNetworkManager.AttendanceData(eventID: event.getID())
        NewNetworkManager().performRequest(.attendance(attendanceData)) { (resultData) in
            
            switch resultData {
            case .withAttendanceData(let arrayWithAttendanceData):
                self.configureUIDependOnArrayOfAttendanceMembers(arrayWithAttendanceData)
            default:
                self.enableGoButton()
            }
        }
    }
    
    func configureUIDependOnArrayOfAttendanceMembers(_ arrayWithAttendanceData: [[String: Any]]) {
        
        let arrayWithAttendanceDataIsNotEmpty = arrayWithAttendanceData.isEmpty == false
        if arrayWithAttendanceDataIsNotEmpty {
            self.attendanceData = arrayWithAttendanceData
            self.attendanceListContainer.isHidden = false
        } else {
            self.attendanceListContainer.isHidden = true
        }
        
        arrayWithAttendanceData.forEach { dictWithAttendanceInfo in
            if let personID = dictWithAttendanceInfo["person"] as? Int,
                let bookingID = dictWithAttendanceInfo["booking"] as? Int,
                personID == CurrentUser.getID() {
                
                self.goButton.setTitle("button_decline_meeting".localized(), for: .normal)
                self.goButton.setBackgroundColor(color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), forState: .normal)
                currentUserBookingIdOnCurrentEvent = bookingID
            }
        }
        enableGoButton()
        
    }
    
    private func enableGoButton() {
        self.goButton.isEnabled = true
    }
    
}

// Slider
extension ArticleDescVC {
    
    func setupImageSlider() {
        slideshow.backgroundColor = UIColor.clear
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
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
