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
    
    var contactsManager = ContactsManager(withFilterType: .members, andType: .person)
    
    var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsManager.contactsData.getContactsData()
        updateUIWithLocalizedText()
        
        registerNibs()
        setTableStyle()
        setDefaultBackground()
        setDelegates()
        setupAsAttendanceView()
        setSwitcherStyle()
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
    
    func setSwitcherStyle() {
        let attr = NSDictionary(object: UIFont(name: "Montserrat-Medium", size: 14)!, forKey: NSAttributedStringKey.font as NSCopying)
        memberTypeSwitcher.setTitleTextAttributes(attr as [NSObject : AnyObject], for: .normal)
    }
    
    func setTableStyle() {
        tableView.backgroundColor = Constants.DefaultColor.background
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func registerNibs() {
        for identifier in ["PersonCell"] {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
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
            tableView.setContentOffset(CGPoint.zero, animated: true)
        default:
            contactsManager.contactType = .person
            tableView.setContentOffset(CGPoint.zero, animated: true)
        }
        searchBar.text = ""
        tableView.reloadData()
    }
}

// TableView methods
extension MembersVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactsManager.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsManager.getNumberOfTableCellsFor(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonCell
            else { return UITableViewCell() }
        
        cell.updateCellWith(contactsManager.getPersonFor(indexPath))
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch contactsManager.contactType {
        case .company:
            let companyView = UINib(nibName: "CompanyView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CompanyView
            let company = contactsManager.getCompanyFor(section)
            let isCellOpened = contactsManager.isOpened(section)
            companyView.updateWith(company, section: section, isOpen: isCellOpened)
            
            // MARK: - Set delegates and values
            companyView.delegate = self
            companyView.collectionView.delegate = self
            companyView.collectionView.dataSource = self
            
            return companyView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch contactsManager.contactType {
        case .company:
            return 120
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CompanyCell else { return }
        cell.collectionView.reloadData()
        cell.collectionView.contentOffset = .zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let profileVC = ProfileVC.getInstance() {
            let publicContactToShow = contactsManager.getPersonFor(indexPath)
            profileVC.publicContactToShow = publicContactToShow
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
}

extension MembersVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let parentTableSection = collectionView.tag
        return contactsManager.getNumberOfCollectionCellsForTable(parentTableSection)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCollectionCell", for: indexPath) as? PersonCollectionCell
            else { return UICollectionViewCell() }
        cell.setRadius(25, withWidth: 1, andColor: UIColor.clear)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PersonCollectionCell else { return }
        let parentTableSection = collectionView.tag
        let person = contactsManager.getPersonFor(collectionIndexPath: indexPath, section: parentTableSection)
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

extension MembersVC: CompanyViewDelegate {
    
    func wasClosedSection(_ section: Int) {
        self.contactsManager.closeSection(section)
        let closedSectionRect = tableView.rectForHeader(inSection: section)
        if contactsManager.areThereMembersInCompanyWith(section) {
            UIView.transition(with: tableView, duration: 1, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
                self.tableView.scrollRectToVisible(closedSectionRect, animated: true)
            }, completion: { result in
            })
        }
    }
    
    func wasOpenedSection(_ section: Int) {
        self.contactsManager.openSection(section)
        let openedSectionRect = tableView.rectForHeader(inSection: section)
        if contactsManager.areThereMembersInCompanyWith(section) {
            UIView.transition(with: tableView, duration: 1, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
                self.tableView.scrollRectToVisible(openedSectionRect, animated: true)
            }, completion: { result in
            })
        }
    }
    
}

