//
//  Menu.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 14.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import Foundation

struct Menu {
    
    var numberOfItems: Int {
        return items.count
    }
    
    var logOutCellIndex: Int {
        return items.count - 1
    }
    
    let items: [Item] = [
        //Item(title: "menu_item_main".localized(), segue: "ShowMain", cellID: "MenuCell", section: 1, iconName: nil),
        Item(title: "menu_item_profile".localized(), segue: "ShowProfile", cellID: "MenuCell", section: 1, iconName: nil),
        Item(title: "menu_item_events".localized(), segue: "ShowEvents", cellID: "MenuCell", section: 1, iconName: nil),
        Item(title: "menu_item_news".localized(), segue: "ShowNews", cellID: "MenuCell", section: 1, iconName: nil),
        Item(title: "menu_item_members".localized(), segue: "ShowMembers", cellID: "MenuCell", section: 1, iconName: nil),
        Item(title: "menu_item_codex".localized(), segue: "ShowCodex", cellID: "MenuCell", section: 1, iconName: nil),
        Item(title: "menu_item_contacts".localized(), segue: "ShowContacts", cellID: "MenuCell", section: 1, iconName: nil),
        Item(title: "menu_item_settings".localized(), segue: "ShowSettings", cellID: "MenuCell", section: 1, iconName: nil),
        Item(title: "menu_item_logout".localized(), segue: "LogOut", cellID: "LogOutCell", section: 1, iconName: nil),
    ]
    
    struct Item {
        let title: String
        let segue: String
        var cellID: String
        let section: Int
        let iconName: String?
        var icon: UIImage? {
            return UIImage(named: iconName ?? "")
        }
        
        
    }
}
