//
//  AboutVC.swift
//  QuitSmokingTogether
//
//  Created by Yaroslav Zhurbilo on 21.11.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class AboutVC: UITableViewController {

    @IBOutlet weak var appVersionCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateLabelsText()
    }
    
    func updateLabelsText() {
        appVersionCell.detailTextLabel?.text = Constants.AppInfo.versionAndBuild
    }
    
    @IBAction func websiteButtonPressed(_ sender: UIButton) {
        Browser.openURLWith(.soft4Status)
    }

}
