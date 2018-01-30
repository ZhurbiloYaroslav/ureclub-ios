//
//  ProfileVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SWRevealViewController

class ProfileVC: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var notificationsButton: UIBarButtonItem!
    public var publicContactToShow: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultBackground()
        swithPrivateAndPublicProfile()
        updateUIWithLocalizedText()
        setupTableView()
    }
    
    @objc func goBackToMembersList(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.makeTransparent()
    }
    
    func setupLeftMenu() {
        if revealViewController() != nil {
            
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            menuButton.image = UIImage(named: "menu")
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    func setupTableView() {
        let navBarHeight = self.navigationController?.navigationBar.frame.height
        let height = UIApplication.shared.statusBarFrame.height + navBarHeight!
        tableView.contentInset = UIEdgeInsetsMake(CGFloat(-(Int(height))), 0, 0, 0)
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        registerCustomCells()
    }
    
    func registerCustomCells() {
        let customCellsIdFromNibs = ["ProfileHeaderCell","FieldCell"]
        for cellID in customCellsIdFromNibs {
            tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        }
    }
    
    func updateUIWithLocalizedText() {
        
    }
    
    @IBAction func notificationsButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowNotifications", sender: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FieldCell", for: indexPath) as? FieldCell
            else { return UITableViewCell() }
        
        switch indexPath {
        case [0,0]:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as? ProfileHeaderCell
                else { return UITableViewCell() }
            cell.updateCellWith(publicContactToShow)
            return cell
        case [1,0]:
            let email = publicContactToShow?.getEmail() ?? CurrentUser.email
            let cellTitle = "profile_email".localized()
            let cellData = FieldCell.CellData(type: .email, icon: #imageLiteral(resourceName: "icon-profile-email"), title: cellTitle, value: email)
            cell.configureWith(cellData)
            return cell
        case [1,1]:
            let phone = publicContactToShow?.getPhone() ?? CurrentUser.phone
            let cellTitle = "profile_phone".localized()
            let cellData = FieldCell.CellData(type: .phone, icon: #imageLiteral(resourceName: "icon-profile-phone"), title: cellTitle, value: phone)
            cell.configureWith(cellData)
            return cell
        case [1,2]:
            let cellTitle = "profile_facebook".localized()
            let cellData = FieldCell.CellData(type: .facebook, icon: #imageLiteral(resourceName: "icon-profile-facebook"), title: cellTitle, value: "")
            cell.configureWith(cellData)
            return cell
        case [1,3]:
            let cellTitle = "profile_linkedin".localized()
            let cellData = FieldCell.CellData(type: .linkedIn, icon: #imageLiteral(resourceName: "icon-profile-linkedIn"), title: cellTitle, value: "")
            cell.configureWith(cellData)
            return cell
        case [2,0]:
            let cellData = FieldCell.CellData(type: .text, icon: UIImage(), title: "", value: CurrentUser.textContent)
            cell.configureWith(cellData)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerTitleText = ""
        
        switch section {
        case 0:
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
        case 1:
            headerTitleText = "profile_section_contacts".localized()
        case 2:
            headerTitleText = "profile_section_about".localized()
        default:
            break
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 36))
        headerView.backgroundColor = Constants.Color.tableSectionsBackground
        
        let headerTitleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.size.width, height: 36))
        headerTitleLabel.text = headerTitleText
        headerTitleLabel.font = UIFont(name: "Montserrat-Medium", size: 18)
        headerTitleLabel.textColor = Constants.Color.tableSectionsTitle
        
        headerView.addSubview(headerTitleLabel)
        
        return headerView
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0,0]:
            performSegue(withIdentifier: "ShowProfileEdit", sender: nil)
        case [1,0]: Browser.openURLWith(.mailUserEmail)
        case [1,1]: Browser.openURLWith(.callUserPhone)
        case [1,2]: Browser.openURLWith(.surfUserFacebook)
        case [1,3]: Browser.openURLWith(.surfUserLinkedIn)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
}

// Methods that determine Public or Private Profile
extension ProfileVC {
    
    func swithPrivateAndPublicProfile() {
        
        if publicContactToShow == nil {
            showThisViewAsPrivateProfile()
        } else {
            showThisViewAsPublicProfile()
        }
    }
    
    func showThisViewAsPrivateProfile() {
        setupLeftMenu()
    }
    
    func showThisViewAsPublicProfile() {
        menuButton.target = self
        menuButton.action = #selector(goBackToMembersList(sender:))
        menuButton.image = UIImage(named: "icon-back")
        notificationsButton.tintColor = UIColor.clear
        notificationsButton.isEnabled = false
    }
}
