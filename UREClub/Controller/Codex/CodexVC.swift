//
//  CodexVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 14.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SWRevealViewController

class CodexVC: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        updateUILabelsWithLocalizedText()
        setupLeftMenu()
        setDelegates()
    }
    
    func setStyle() {
        self.setCustomBackground()
        tableView.backgroundColor = Constants.Color.skyLight
        tableView.sectionIndexColor = Constants.Color.skyLight
    }
    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func updateUILabelsWithLocalizedText() {
        
        navigationItem.title = "Code of ethics"
        
    }
    
    func setupLeftMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
}

extension CodexVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Codex().numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CodexCell", for: indexPath) as? CodexCell else {
            return UITableViewCell()
        }

        cell.updateCellWith(indexPath)
        return cell
    }
    
}
