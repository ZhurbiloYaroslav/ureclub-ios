//
//  MembersVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//
// TODO: Refactor cell folding with: https://github.com/jeantimex/ios-swift-collapsible-table-section
                            // or:   https://www.appcoda.com/expandable-table-view/

import UIKit
import SWRevealViewController

extension MembersVC: ContactsDataDelegate {
    func didReceiveContacts() {
        self.tableView.reloadData()
    }
}

extension MembersVC {
    
    func setupAsAttendanceView() {
        if contactsManager.contactsData.isItAttendanceScreen {
            //replaceMenuButtonWithBack()
            memberTypeSwitcher.isHidden = true
            contactsManager.contactType = .person
            navigationItem.title = "screen_attendance_title".localized()
        } else {
            setupLeftMenu()
        }
    }
    
    func replaceMenuButtonWithBack() {
        let backItem = UIBarButtonItem(image: UIImage(named:"icon-back"), style: .plain, target: self, action: #selector(menuButtonTapped(sender:)))
        navigationItem.backBarButtonItem = backItem
    }
    
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

class MembersVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var memberTypeSwitcher: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate var tableViewCellCoordinator: [Int: IndexPath] = [:]
    
    var contactsManager = ContactsManager(withFilterType: .members, andType: .person)
    
    var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsManager.contactsData.getContactsData()
        updateUIWithLocalizedText()
        
        setTableStyle()
        setDefaultBackground()
        setDelegates()
        setupAsAttendanceView()
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
            
            menuButton = UIBarButtonItem(image: UIImage(named:"menu"), style: .plain, target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            navigationItem.leftBarButtonItem = menuButton
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
            
            let genericContact = contactsManager.getContactForCompanyTypeCell(indexPath)
            
            if let company = genericContact as? Company {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as? CompanyCell
                    else { return UITableViewCell() }
                
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                
                let tag = 10000*(indexPath.section+1)+indexPath.row
                cell.collectionView.tag = tag
                tableViewCellCoordinator[tag] = indexPath
                
                cell.tag = CellTag.company.rawValue
                cell.updateCellWith(company)
                
                return cell
                
            } else if let person = genericContact as? Person {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonCell
                    else { return UITableViewCell() }
                
                cell.tag = CellTag.person.rawValue
                cell.updateCellWith(person)
                
                return cell
                
            } else {
                return UITableViewCell()
            }
            
        case .person:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonCell
                else { return UITableViewCell() }
            
            cell.tag = CellTag.person.rawValue
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
        
        guard let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        let tagForSelectedRow = selectedCell.tag
        
        switch tagForSelectedRow {
        case CellTag.company.rawValue:
            
            switch contactsManager.openedCellIndexPath {
            case nil:
                contactsManager.openedCellIndexPath = indexPath
            default:
                contactsManager.openedCellIndexPath = nil
            }
            tableView.reloadData()
            
        case CellTag.person.rawValue:
            if (tableView.cellForRow(at: indexPath) as? PersonCell) != nil {
                if let profileVC = ProfileVC.getInstance() {
                    let publicContactToShow = contactsManager.getPersonFor(indexPath)
                    profileVC.publicContactToShow = publicContactToShow
                    navigationController?.pushViewController(profileVC, animated: true)
                }
            }
            
        default:
            break
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

extension MembersVC {
    
    enum CellTag: Int {
        case person = 1
        case company = 2
    }
    
}

