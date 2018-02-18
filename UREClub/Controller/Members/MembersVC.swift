//
//  MembersVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SWRevealViewController

extension MembersVC: ContactsDataDelegate {
    func didReceiveContacts() {
        self.tableView.reloadData()
    }
}

class MembersVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var memberTypeSwitcher: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate var tableViewCellCoordinator: [Int: IndexPath] = [:]
    
    var contactsManager = ContactsManager(withFilterType: .members, andType: .person)
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsManager.contactsData.getContactsData()
        setupLeftMenu()
        updateUIWithLocalizedText()
        
        setTableStyle()
        setDefaultBackground()
        setDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contactsManager.contactsData.getContactsData()
        navigationController?.setDefaultStyle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.makeTransparent()
    }
    
    func setTableStyle() {
        tableView.backgroundColor = Constants.DefaultColor.background
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        contactsManager.contactsData.delegate = self
    }
    
    func setupLeftMenu() {
        if revealViewController() != nil {
            
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func updateUIWithLocalizedText() {
        
        navigationItem.title = "screen_members_title".localized()
        
    }
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        if let filterVC = FilterVC.getInstance() {
            filterVC.filterManager.currentFilter = contactsManager.contactsData.contactsFilter
            navigationController?.pushViewController(filterVC, animated: true)
        }
    }

    @IBAction func memberTypeSwitcherChanged(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 1:
            contactsManager.contactType = .company
        default:
            contactsManager.contactType = .person
        }
        searchBar.text = ""
        tableView.reloadData()
    }
}

// TableView methods
extension MembersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsManager.getNumberOfTableCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch contactsManager.contactType {
        case .company:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as? CompanyCell
                else { return UITableViewCell() }
            
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            
            let tag = 10000*(indexPath.section+1)+indexPath.row
            cell.collectionView.tag = tag
            tableViewCellCoordinator[tag] = indexPath
            
            cell.updateCellWith(contactsManager.getCompanyFor(indexPath))
            
            return cell
        case .person:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonCell
                else { return UITableViewCell() }
            cell.updateCellWith(contactsManager.getPersonFor(indexPath))
            return cell
        default:
            return UITableViewCell()
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
            let publicContactToShow = contactsManager.getPersonFor(indexPath)
            guard let destination = segue.destination as? ProfileVC else { return }
            destination.publicContactToShow = publicContactToShow
        default:
            print("Was used undefined segue")
        }
    }
}

extension MembersVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let parentTableCellIndexPath = tableViewCellCoordinator[collectionView.tag] else { return 0 }
        return contactsManager.getNumberOfCollectionCellsForTable(parentTableCellIndexPath)
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
        
        let person = contactsManager.getPersonFor(collectionIndexPath: indexPath, tableIndexPath: parentTableCellIndexPath)
        cell.updateCellWith(person)
    }
}

extension MembersVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        contactsManager.contactsData.contactsFilter.searchString = searchBar.text ?? ""
        tableView.reloadData()
    }
    
}



