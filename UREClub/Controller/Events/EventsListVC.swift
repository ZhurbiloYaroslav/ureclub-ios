//
//  EventsListVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SWRevealViewController

class EventsListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var eventsPeriodControl: TopSegmentedContol!
    @IBOutlet weak var eventsListTypeControl: UISegmentedControl!
    
    public var dataFromNotification: DataFromPushNotification?
    
    private var eventsManager = EventsManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getArrayWithEvents()
        setDelegates()
        registerNibs()
        setupLeftMenu()
        updateUIWithLocalizedText()
        setSwitcherStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eventsListTypeControl.selectedSegmentIndex = eventsManager.eventsFilter.getEventViewType().getSelectedIndex
        
        tableView.reloadData()
    }
    
    func setSwitcherStyle() {
        let attrTop = NSDictionary(object: UIFont(name: "Montserrat-Regular", size: 12)!, forKey: NSAttributedStringKey.font as NSCopying)
        let attrBottom = NSDictionary(object: UIFont(name: "Montserrat-Medium", size: 14)!, forKey: NSAttributedStringKey.font as NSCopying)
        eventsPeriodControl.setTitleTextAttributes(attrTop as [NSObject : AnyObject], for: .normal)
        eventsListTypeControl.setTitleTextAttributes(attrBottom as [NSObject : AnyObject], for: .normal)
    }
    
    func setupTableView() {
        self.tableView.backgroundColor = Constants.DefaultColor.background
        self.setDefaultBackground()
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func eventViewTypeSwitcherChanged(_ sender: UISegmentedControl) {
        eventsManager.eventsFilter.setEventViewTypeFrom(value: sender.selectedSegmentIndex)
        reloadCurrentView()
    }
    
    @IBAction func eventPeriodSwitcherChanged(_ sender: UISegmentedControl) {
        eventsManager.eventsFilter.setEventPeriodFrom(value: sender.selectedSegmentIndex)
        reloadCurrentView()
    }
    
    func reloadCurrentView() {
        tableView.reloadData()
    }
    
    private func getArrayWithEvents() {
        let spinner = UIViewController.displaySpinner(onView: view)
        eventsManager.getArrayWithEvents { (errors) in
            UIViewController.removeSpinner(spinner: spinner)
            if errors == nil {
                self.tableView.reloadData()
                self.presentEventFromNotification()
            }
        }
    }
    
    private func presentEventFromNotification() {
        if let data = dataFromNotification, data.isEvent,
            let eventDescVC = ArticleDescVC.getInstance(),
            let currentEvent = eventsManager.getEventByPostID(data.postIDs) {
            eventDescVC.currentArticle = currentEvent
            navigationController?.pushViewController(eventDescVC, animated: true)
        }
    }
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func registerNibs() {
        tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")
        tableView.register(UINib(nibName: "CalendarCell", bundle: nil), forCellReuseIdentifier: "CalendarCell")
    }
    
    private func setupLeftMenu() {
        if revealViewController() != nil {
            
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    private func updateUIWithLocalizedText() {
        
        navigationItem.title = "screen_events_title".localized()
        
        eventsPeriodControl.setTitle("control_event_upcoming".localized(), forSegmentAt: 0)
        eventsPeriodControl.setTitle("control_event_past".localized(), forSegmentAt: 1)
        
        eventsListTypeControl.setTitle("control_event_list".localized(), forSegmentAt: 0)
        eventsListTypeControl.setTitle("control_event_calendar".localized(), forSegmentAt: 1)
        
    }
    
    private func showSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .white
        spinner.center = view.center
        spinner.startAnimating()
        
        view.addSubview(spinner)
        view.bringSubview(toFront: spinner)
        
        return spinner
    }
    
    private func hideSpinner(_ spinner: UIActivityIndicatorView) {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        if let filterVC = FilterVC.getInstance() {
            filterVC.filterManager.currentFilter = eventsManager.eventsFilter
            navigationController?.pushViewController(filterVC, animated: true)
        }
    }
    
}

extension EventsListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventsManager.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsManager.getNumberOfEventsIn(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let eventViewType = eventsManager.eventsFilter.getEventViewType()
        switch eventViewType {
        case .calendar:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath) as? CalendarCell
                else { return UITableViewCell() }
            let event = eventsManager.getEventFor(indexPath)
            cell.updateCellWith(event)
            
            return cell
            
        case .list:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell
                else { return UITableViewCell() }
            cell.event = eventsManager.getEventFor(indexPath)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let articleDescVC = ArticleDescVC.getInstance() {
            articleDescVC.currentArticle = eventsManager.getEventFor(indexPath)
            navigationController?.pushViewController(articleDescVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch eventsManager.eventsFilter.getEventViewType() {
        case .calendar:
            let headerTitleText = eventsManager.getHeaderTitleFor(section)
            let headerView = UIView.getCustomHeaderViewWith(headerTitleText, forTableView: tableView    )
            headerView.backgroundColor = UIColor(red:0.72, green:0.82, blue:0.84, alpha:1.0)
            
            return headerView
        case .list:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch eventsManager.eventsFilter.getEventViewType() {
        case .calendar: return 36
        case .list: return CGFloat.leastNonzeroMagnitude
        }
    }
    
}

extension EventsListVC: EventCellDelegate {
    func didPressLocationOnCellWithEvent(_ event: Event) {
        Browser.openURLWith(event.location.getGoogleMapsLink())
    }
}
