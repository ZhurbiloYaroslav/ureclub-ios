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
    
    let items: [Item] = [
        Item(title: "menu_item_main".localized(), segue: "ShowMain", section: 1, iconName: nil),
        Item(title: "menu_item_profile", segue: "ShowProfile", section: 1, iconName: nil),
        Item(title: "menu_item_events", segue: "ShowEvents", section: 1, iconName: nil),
        Item(title: "menu_item_news", segue: "ShowNews", section: 1, iconName: nil),
        Item(title: "menu_item_codex", segue: "ShowCodex", section: 1, iconName: nil),
        Item(title: "menu_item_members", segue: "ShowMembers", section: 1, iconName: nil),
        Item(title: "menu_item_contacts", segue: "ShowContacts", section: 1, iconName: nil),
        Item(title: "menu_item_settings", segue: "ShowSettings", section: 1, iconName: nil),
    ]
    
    struct Item {
        let title: String
        let segue: String
        let cellID: String = "MenuCell"
        let section: Int
        let iconName: String?
        var icon: UIImage? {
            return UIImage(named: iconName ?? "")
        }
    }
}
