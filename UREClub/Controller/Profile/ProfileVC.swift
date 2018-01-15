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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLeftMenu()
        self.setDefaultBackground()
        
        updateUILabelsWithLocalizedText()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.makeTransparent()
    }
    
    func setupLeftMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
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
    
    func updateUILabelsWithLocalizedText() {
        
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
            return cell
        case [1,0]:
            let cellData = FieldCell.CellData(type: .Email, icon: #imageLiteral(resourceName: "icon-gmail"), title: "Email:", value: CurrentUser.email)
            cell.configureWith(cellData)
            return cell
        case [1,1]:
            let cellData = FieldCell.CellData(type: .Phone, icon: #imageLiteral(resourceName: "icon-phone"), title: "Phone:", value: CurrentUser.phone)
            cell.configureWith(cellData)
            return cell
        case [1,2]:
            let cellData = FieldCell.CellData(type: .Facebook, icon: #imageLiteral(resourceName: "icon-facebook-large"), title: "Facebook:", value: CurrentUser.facebook_link)
            cell.configureWith(cellData)
            return cell
        case [1,3]:
            let cellData = FieldCell.CellData(type: .LinkedIn, icon: #imageLiteral(resourceName: "icon-linkedin"), title: "LinkedIn:", value: CurrentUser.linkedIn_link)
            cell.configureWith(cellData)
            return cell
        case [2,0]:
            let cellData = FieldCell.CellData(type: .Text, icon: UIImage(), title: "", value: CurrentUser.textContent)
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
            headerTitleText = "profile_section_about".localized() + " " + CurrentUser.firstName
        default:
            break
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 36))
        headerView.backgroundColor = Constants.Color.blueLight
        
        let headerTitleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.size.width, height: 36))
        headerTitleLabel.text = headerTitleText
        headerTitleLabel.font = UIFont(name: "Montserrat-Medium", size: 18)
        headerTitleLabel.textColor = Constants.Color.skyDark
        
        headerView.addSubview(headerTitleLabel)
        
        return headerView
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [1,0]: Browser.openURLWith(.Mail_User_Email)
        case [1,1]: Browser.openURLWith(.Call_User_Phone)
        case [1,2]: Browser.openURLWith(.Surf_User_Facebook)
        case [1,3]: Browser.openURLWith(.Surf_User_LinkedIn)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
}
