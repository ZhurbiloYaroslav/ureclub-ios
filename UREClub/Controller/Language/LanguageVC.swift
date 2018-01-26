//
//  LanguageVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 26.01.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class LanguagePickerVC: UITableViewController {
    
    let languageManager = LanguageManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUIWithLocalizedText()
        tableView.reloadData()
    }
    
    func updateUIWithLocalizedText() {
        
        navigationItem.title = "screen_language_title".localized()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageManager.getNumberOfCells()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as? LanguageCell
            else { return UITableViewCell() }

        let language = languageManager.getLanguageFor(indexPath)
        cell.updateCellWith(language)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        languageManager.saveCurrentLanguageWith(indexPath)
        
        updateUIWithLocalizedText()
        navigationController?.popViewController(animated: true)
    }

}
