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
    
    var settingsCells = SettingsCells()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLeftMenu()
        self.setDefaultBackground()
        
        updateUIWithLocalizedText()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUIWithLocalizedText()
        tableView.reloadData()
    }
    
    func setupLeftMenu() {
        if revealViewController() != nil {
            
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64
            
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
        let customCellsIdFromNibs = ["ChangePasswordCell","ChangeLanguageCell","AboutCell"]
        for cellID in customCellsIdFromNibs {
            tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        }
    }
    
    func updateUIWithLocalizedText() {
        
        navigationItem.title = "screen_settings_title".localized()
    }

}

extension SettingsVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settingsCells.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsCells.getNumberOfCellsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsCells.getCellForTable(tableView, andIndexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerTitleText = ""
        
        switch section {
        case 0:
            headerTitleText = "settings_section_security".localized()
        case 1:
            headerTitleText = "settings_section_language".localized()
        case 2:
            headerTitleText = "about_app_section".localized()
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0,0]:
            if let passwordEditVC = PasswordEditVC.getInstance() {
                navigationController?.pushViewController(passwordEditVC, animated: true)
            }
        case [1,0]:
            if let languagePickerVC = LanguagePickerVC.getInstance() {
                navigationController?.pushViewController(languagePickerVC, animated: true)
            }
        case [2,0]:
            if let aboutVC = AboutVC.getInstance() {
                navigationController?.pushViewController(aboutVC, animated: true)
            }
        default:
            break
        }
    }
}
