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
            CurrentUser.logOut {
                self.performSegue(withIdentifier: menuItem.segue, sender: nil)
            }
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
    
    func setCustomStyle() {
        self.view.backgroundColor = Constants.Color.coalLight
    }
    
}

