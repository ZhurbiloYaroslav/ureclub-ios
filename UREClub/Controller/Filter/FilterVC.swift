//
//  FilterVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 19.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var filterManager = FilterManager(withFilter: Filter(withType: .events))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultBackground()
        setDelegates()
        updateUIWithLocalizedText()
    }
    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setDefaultStyle()
    }
    
    func updateUIWithLocalizedText() {
        
        navigationItem.title = "screen_filter_title".localized()
        
    }

}

extension FilterVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterManager.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterManager.getNumberOfCellsIn(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        cell.textLabel?.text = filterManager.getSectionCellTitleFor(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filterManager.getTitleFor(section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerTitleText = filterManager.getTitleFor(section)

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 36))
        headerView.backgroundColor = Constants.Color.tableSectionsBackground

        let headerTitleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.size.width, height: 36))
        headerTitleLabel.text = headerTitleText
        headerTitleLabel.font = UIFont(name: "Montserrat-Medium", size: 18)
        headerTitleLabel.textColor = Constants.Color.tableSectionsTitle

        headerView.addSubview(headerTitleLabel)

        return headerView

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
