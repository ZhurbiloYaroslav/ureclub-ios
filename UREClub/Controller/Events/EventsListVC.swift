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
    @IBOutlet weak var eventsPeriodControl: EventsSegmCont!
    @IBOutlet weak var eventsListTypeControl: UISegmentedControl!
    
    var eventsManager = EventsManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getArrayWithEvents()
        setDelegates()
        registerNibs()
        setupLeftMenu()
        updateUILabelsWithLocalizedText()
    }
    
    func setupTableView() {
        self.tableView.backgroundColor = Constants.Color.skyLight
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
    
    func getArrayWithEvents() {
        eventsManager.getArrayWithEvents { (errors) in
            if errors == nil {
                self.tableView.reloadData()
            }
        }
    }
    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func registerNibs() {
        tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
        tableView.register(UINib(nibName: "CalendarCell", bundle: nil), forCellReuseIdentifier: "CalendarCell")
    }
    
    func setupLeftMenu() {
        if revealViewController() != nil {
            
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    func updateUILabelsWithLocalizedText() {
        
        navigationItem.title = "screen_events_title".localized()
        
        eventsPeriodControl.setTitle("control_event_upcoming".localized(), forSegmentAt: 0)
        eventsPeriodControl.setTitle("control_event_past".localized(), forSegmentAt: 1)
        
        eventsListTypeControl.setTitle("control_event_calendar".localized(), forSegmentAt: 0)
        eventsListTypeControl.setTitle("control_event_list".localized(), forSegmentAt: 1)
        
    }
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowFilter", sender: nil)
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell
                else { return UITableViewCell() }
            let event = eventsManager.getEventFor(indexPath)
            cell.updateCellWith(event)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowEventDesc", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventsManager.getHeaderTitleFor(section)
    }
}

//MARK: SEGUES
extension EventsListVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier else {
            return
        }
        
        switch segueID {
        case "ShowEventDesc":
            guard let eventDescVC = segue.destination as? EventDescVC else {
                return
            }
            if let indexPath = sender as? IndexPath {
                eventDescVC.currentEvent = eventsManager.getEventFor(indexPath)
            }
        case "ShowFilter":
            guard let filterVC = segue.destination as? FilterVC else { return }
            filterVC.filterManager.currentFilter = eventsManager.eventsFilter
        default:
            print("Was used undefined segue")
            return
        }
    }
}
