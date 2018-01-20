//
//  MembersVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SWRevealViewController

class MembersVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var memberTypeSwitcher: UISegmentedControl!
    
    fileprivate var tableViewCellCoordinator: [Int:IndexPath] = [:]
    
    var membersManager = MembersManager()
    var membersFilter = Filter(withType: .members)
    var currentMemberViewType = MembersManager.MemberType.Person
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        setupLeftMenu()
        updateUILabelsWithLocalizedText()
        
        setTableStyle()
        setDefaultBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setDefaultStyle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.makeTransparent()
    }
    
    func setTableStyle() {
        tableView.backgroundColor = Constants.Color.skyLight
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
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
        
        navigationItem.title = "screen_members_title".localized()
        
    }
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowFilter", sender: nil)
    }

    @IBAction func memberTypeSwitcherChanged(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 1:
            currentMemberViewType = .Company
        default:
            currentMemberViewType = .Person
        }
        tableView.reloadData()
    }
}

// TableView methods
extension MembersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersManager.getNumberOfTableCellsFor(currentMemberViewType)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch currentMemberViewType {
        case .Company:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as? CompanyCell
                else { return UITableViewCell() }
            
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            
            let tag = 10000*(indexPath.section+1)+indexPath.row
            cell.collectionView.tag = tag
            tableViewCellCoordinator[tag] = indexPath
            
            cell.updateCellWith(membersManager.getCompanyFor(indexPath))
            
            return cell
        case .Person:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonCell
                else { return UITableViewCell() }
            cell.updateCellWith(membersManager.getPersonFor(indexPath))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CompanyCell else { return }
        cell.collectionView.reloadData()
        cell.collectionView.contentOffset = .zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView.cellForRow(at: indexPath) as? PersonCell) != nil {
            performSegue(withIdentifier: "ShowProfile", sender: indexPath)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueID = segue.identifier else { return }
        
        switch segueID {
        case "ShowProfile":
            guard let indexPath = sender as? IndexPath else { return }
            let publicContactToShow = membersManager.getPersonFor(indexPath)
            guard let destination = segue.destination as? ProfileVC else { return }
            destination.publicContactToShow = publicContactToShow
        case "ShowFilter":
            guard let filterVC = segue.destination as? FilterVC else { return }
            filterVC.filterManager.currentFilter = membersFilter
        default:
            print("Was used undefined segue")
        }
    }
}

extension MembersVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let parentTableCellIndexPath = tableViewCellCoordinator[collectionView.tag] else { return 0 }
        return membersManager.getNumberOfCollectionCellsForTable(parentTableCellIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCollectionCell", for: indexPath) as? PersonCollectionCell
            else { return UICollectionViewCell() }
        cell.setRadius(25, withWidth: 1, andColor: UIColor.clear)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PersonCollectionCell
            else { return }
        guard let parentTableCellIndexPath = tableViewCellCoordinator[collectionView.tag] else { return }
        
        let person = membersManager.getPersonFor(collectionIndexPath: indexPath, tableIndexPath: parentTableCellIndexPath)
        cell.updateCellWith(person)
    }
}
