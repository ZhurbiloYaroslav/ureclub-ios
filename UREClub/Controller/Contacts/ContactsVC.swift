//
//  ContactsNewVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.03.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SWRevealViewController

extension ContactsVC: ContactsDataDelegate {
    func didReceiveContacts() {
        
        if let spinner = spinner {
            UIViewController.removeSpinner(spinner: spinner)
        }
        
        self.tableView.reloadData()
    }
}

class ContactsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var contactsTabControl: TopSegmentedContol!
    
    fileprivate var contactsManager = ContactsManager(withFilterType: .contacts, andType: .worker)
    fileprivate var viewType: ContactsViewType = .team
    fileprivate var spinner: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsManager.contactsData.getContactsData()
        spinner = UIViewController.displaySpinner(onView: view)
        
        setDelegates()
        setupLeftMenu()
        updateUIWithLocalizedText()
        
        registerNibs()
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
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        contactsManager.contactsData.delegate = self
    }
    
    func setupLeftMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    func setTableStyle() {
        tableView.backgroundColor = Constants.DefaultColor.background
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func registerNibs() {
        let customCellsIdFromNibs = ["ContactsCell", "AddressCell", "FieldCell", "ProfileButtonsCell"]
        for cellID in customCellsIdFromNibs {
            tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        }
    }
    
    func updateUIWithLocalizedText() {
        
        navigationItem.title = "screen_contacts_title".localized()
        contactsTabControl.setTitle("control_contacts_team".localized(), forSegmentAt: 0)
        contactsTabControl.setTitle("control_contacts_office".localized(), forSegmentAt: 1)
    }
    
    @IBAction func contactsTypeSwitcherChanged(_ sender: UISegmentedControl) {
        viewType = ContactsViewType.getInstanceWith(sender.selectedSegmentIndex)
        reloadCurrentView()
    }
    
    func reloadCurrentView() {
        tableView.reloadData()
    }
    
    enum ContactsViewType: Int {
        case team = 0
        case address = 1
        
        static func getInstanceWith(_ value: Int) -> ContactsViewType {
            switch value {
            case address.rawValue:
                return .address
            default:
                return .team
            }
        }
    }
    
    @objc func wasPressedFacebookButton(_ sender: UIButton) {
        Browser.openURLWith(.surfUrecFacebook)
    }
    
    @objc func wasPressedLinkedInButton(_ sender: UIButton) {
        Browser.openURLWith(.surfUrecLinkedIn)
    }

}

extension ContactsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch viewType {
        case .team:
            return 1
        case .address:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewType {
        case .team:
            return contactsManager.getNumberOfTableCellsFor(section)
        case .address:
            return getNumberOfRowsForAddressTypeIn(section)
        }
    }
    
    func getNumberOfRowsForAddressTypeIn(_ section: Int) -> Int {
        switch section {
        case 0:
            return 1 // Address
        case 1:
            return 6
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewType {
        case .team:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath) as? ContactsCell
                else { return UITableViewCell() }
            cell.updateCellWith(contactsManager.getPersonFor(indexPath))
            return cell
            
        case .address:
            return getCellForAddressViewWith(indexPath)
        }
        
    }
    
    func getCellForAddressViewWith(_ indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FieldCell", for: indexPath) as? FieldCell
            else { return UITableViewCell() }
        
        switch indexPath {
        case [0,0]:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as? AddressCell
                else { return UITableViewCell() }
            return cell
            
        case [1,0]:
            let cellTitle = "header_address".localized()
            let address = "ureclub_address".localized()
            let cellData = FieldCell.CellData(type: .address, icon: UIImage(), title: cellTitle, value: address)
            cell.configureWith(cellData)
            return cell
            
        case [1,1]:
            let cellTitle = "profile_phone".localized()
            let cellData = FieldCell.CellData(type: .phone, icon: UIImage(), title: cellTitle, value: "+380442276753")
            cell.configureWith(cellData)
            return cell
            
        case [1,2]:
            let cellTitle = "profile_phone".localized()
            let cellData = FieldCell.CellData(type: .phone, icon: UIImage(), title: cellTitle, value: "+380443605158")
            cell.configureWith(cellData)
            return cell
            
        case [1,3]:
            let cellTitle = "profile_email".localized()
            let cellData = FieldCell.CellData(type: .email, icon: UIImage(), title: cellTitle, value: "info@ureclub.com")
            cell.configureWith(cellData)
            return cell
            
        case [1,4]:
            let cellTitle = "header_website".localized()
            let cellData = FieldCell.CellData(type: .email, icon: UIImage(), title: cellTitle, value: "www.ureclub.com")
            cell.configureWith(cellData)
            return cell
            
        case [1,5]:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileButtonsCell", for: indexPath) as? ProfileButtonsCell
                else { return UITableViewCell() }
            
            cell.facebookButton.addTarget(self, action: #selector(ContactsVC.wasPressedFacebookButton(_:)), for: .touchUpInside)
            cell.linkedInButton.addTarget(self, action: #selector(ContactsVC.wasPressedLinkedInButton(_:)), for: .touchUpInside)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewType {
        case .team:
            if let profileVC = ProfileVC.getInstance() {
                let publicContactToShow = contactsManager.getPersonFor(indexPath)
                profileVC.publicContactToShow = publicContactToShow
                navigationController?.pushViewController(profileVC, animated: true)
            }
        case .address:
            switch indexPath {
            case [0,0]: // Map
                Browser.openUREClubOnMap()
            case [1,0]: // Address
                Browser.openUREClubOnMap()
            case [1,1]: // Phone
                Browser.openURLWith(.callUREClub6753)
            case [1,2]: // Phone 2
                Browser.openURLWith(.callUREClub5158)
            case [1,3]: // Email
                Browser.openURLWith(.mailUREClubInfo)
            case [1,4]: // Website
                Browser.openURLWith(.surfUrecWebSite)
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerTitleText = ""
        
        switch section {
        case 0:
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            return headerView
        case 1:
            headerTitleText = "profile_section_contacts".localized()
        default:
            break
        }
        
        let headerView = UIView.getCustomHeaderViewWith(headerTitleText, forTableView: tableView)
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
}
