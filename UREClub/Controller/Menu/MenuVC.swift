//
//  MenuVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class MenuVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCustomStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.frame.size.width = self.revealViewController().rearViewRevealWidth
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Menu().numberOfItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = Menu().items[indexPath.row].cellID
        
        switch cellID {
        case "MenuCell":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MenuCell else {
                return UITableViewCell()
            }
            cell.updateCellWith(indexPath: indexPath)
            return cell
        case "LogOutCell":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? LogOutCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.updateCellWith(indexPath: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let menuItem = Menu().items[indexPath.row]
        
        switch menuItem.segue {
        case "LogOut":
            break
        default:
            performSegue(withIdentifier: menuItem.segue, sender: nil)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let someExtraSpace: CGFloat = 60
        let heightOfTable = Int(self.view.frame.size.height - someExtraSpace)
        let heightOfCell = CGFloat((heightOfTable) / Menu().numberOfItems)
        
        switch indexPath.row {
        case Menu().logOutCellIndex:
            return heightOfCell + 20
        default:
            return heightOfCell
        }
    }
    
    // MARK: - Logout methods
    func showAlertBeforeLogOutFor(_ menuItem: Menu.Item) {
        let alertTitle = "alert_logout_title".localized()
        let alertMessage = "alert_logout_message".localized()
        let alertController = UIAlertController(title: alertTitle,
                                                message: alertMessage,
                                                preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "alert_button_cancel".localized(), style: .default)
        let okAction = UIAlertAction(title: "alert_logout_button_ok".localized(), style: .default) { (alertAction) in
            self.performLogOutFor(menuItem)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func performLogOutFor(_ menuItem: Menu.Item) {
        CurrentUser.logOut {
            self.performSegue(withIdentifier: menuItem.segue, sender: nil)
        }
    }
    
    func setCustomStyle() {
        self.view.backgroundColor = Constants.Color.coalLight
    }
    
}

extension MenuVC: LogOutCellDelegate {
    func didTapOnProfileIcon() {
        moveToProfile()
    }
    
    func didTapOnCell() {
        let menuItem = Menu().items.last!
        showAlertBeforeLogOutFor(menuItem)
    }
    
    func moveToProfile() {
        let menuItem = Menu().items.first! // Profile segue
        self.performSegue(withIdentifier: menuItem.segue, sender: nil)
    }
}

