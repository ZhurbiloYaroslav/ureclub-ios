//
//  SettingsVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SWRevealViewController

class SettingsVC: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var isUnderEditing: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLeftMenu()
        self.setDefaultBackground()
        
        updateUILabelsWithLocalizedText()
        setupTableView()
    }
    
    @IBAction func EditButtonPressed(_ sender: UIBarButtonItem) {
        isUnderEditing = true
        tableView.reloadData()
    }
    
    func setupLeftMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    func setupTableView() {
        
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return 3
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FieldCell", for: indexPath) as? FieldCell
            else { return UITableViewCell() }
        
        cell.isUnderEditing = isUnderEditing
        
        switch indexPath {
        case [0,0]:
            let cellData = FieldCell.CellData(type: .NameFull, icon: UIImage(), title: "Full name:", value: CurrentUser.fullName)
            cell.configureWith(cellData)
        case [0,1]:
            let cellData = FieldCell.CellData(type: .CompanyName, icon: UIImage(), title: "Company:", value: CurrentUser.company.company.name)
            cell.configureWith(cellData)
        case [0,2]:
            let cellData = FieldCell.CellData(type: .UserPosition, icon: UIImage(), title: "Position:", value: CurrentUser.company.position)
            cell.configureWith(cellData)
        case [0,3]:
            let cellData = FieldCell.CellData(type: .Email, icon: UIImage(), title: "Email:", value: CurrentUser.email)
            cell.configureWith(cellData)
        case [0,4]:
            let cellData = FieldCell.CellData(type: .Phone, icon: UIImage(), title: "Mobile:", value: CurrentUser.phone)
            cell.configureWith(cellData)
        case [1,0]:
            let cellData = FieldCell.CellData(type: .LinkedIn, icon: #imageLiteral(resourceName: "icon-facebook"), title: "", value: "LinkedIn")
            cell.configureWith(cellData)
        case [1,1]:
            let cellData = FieldCell.CellData(type: .Facebook, icon: #imageLiteral(resourceName: "icon-facebook"), title: "", value: "Facebook")
            cell.configureWith(cellData)
        case [1,2]:
            let cellData = FieldCell.CellData(type: .Twitter, icon: #imageLiteral(resourceName: "icon-facebook"), title: "", value: "Twitter")
            cell.configureWith(cellData)
        case [2,0]:
            let cellData = FieldCell.CellData(type: .Text, icon: UIImage(), title: "", value: "lorem_ipsum_text".localized())
            cell.configureWith(cellData)
        case [3,0]:
            let cellData = FieldCell.CellData(type: .Password, icon: UIImage(), title: "Change password", value: "")
            cell.configureWith(cellData)
        case [4,0]:
            let cellData = FieldCell.CellData(type: .UserPosition, icon: UIImage(), title: "", value: "English")
            cell.configureWith(cellData)
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerTitleText = ""
        
        switch section {
        case 0:
            headerTitleText = "settings_section_main".localized()
        case 1:
            headerTitleText = "settings_section_social".localized()
        case 2:
            headerTitleText = "settings_section_about".localized()
        case 3:
            headerTitleText = "settings_section_security".localized()
        case 4:
            headerTitleText = "settings_section_language".localized()
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }

}
