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
    
    var arrayWithEvents = [Event]()
    var networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = Constants.Color.skyLight
        self.setDefaultBackground()
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        getArrayWithEvents()
        setDelegates()
        registerNibs()
        setupLeftMenu()
        updateUILabelsWithLocalizedText()
    }
    
    func getArrayWithEvents() {
        networkManager.retrieveInfoForPath(.events) { (errors) in
            print("---Errors in events", errors)
        }
    }
    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        networkManager.delegate = self
    }
    
    func registerNibs() {
        tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
    }
    
    func setupLeftMenu() {
        if revealViewController() != nil {
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayWithEvents.count > 0 {
            return arrayWithEvents.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell
            else { return UITableViewCell() }
        let event = arrayWithEvents[indexPath.row]
        cell.updateCellWith(event)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowEventDesc", sender: indexPath)
    }
}

extension EventsListVC: NetworkManagerDelegate {
    func didLoad(arrayWithEvents: [Event]) {
        self.arrayWithEvents = arrayWithEvents
        tableView.reloadData()
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
                eventDescVC.currentEvent = arrayWithEvents[indexPath.row]
            }
        case "ShowFilter":
            break
        default:
            print("Was used undefined segue")
            return
        }
    }
}
