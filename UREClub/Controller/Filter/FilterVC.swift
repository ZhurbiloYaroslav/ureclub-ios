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
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        performFilter()
    }
    
    func performFilter() {
        navigationController?.popViewController(animated: true)
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
        cell.textLabel?.font = UIFont(name: "Montserrat-Regular", size: 17)!
        cell.accessoryType = filterManager.cellAccessoryTypeFor(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filterManager.wasPressedButtonWith(indexPath)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filterManager.getTitleFor(section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerTitleText = filterManager.getTitleFor(section)
        let headerView = UIView.getCustomHeaderViewWith(headerTitleText, forTableView: tableView)

        return headerView

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
