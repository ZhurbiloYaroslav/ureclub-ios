//
//  ContactsVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SWRevealViewController

extension ContactsVC: ContactsDataDelegate {
    func didReceiveContacts() {
        self.tableView.reloadData()
    }
}

class ContactsVC: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var contactsManager = ContactsManager(withFilterType: .contacts, andType: .worker)

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
        contactsManager.contactsData.getContactsData()
        self.setDefaultBackground()
        setupLeftMenu()
        updateUIWithLocalizedText()
        
        registerNibs()
        setTableStyle()
        setDefaultBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contactsManager.contactsData.getContactsData()
        navigationController?.setDefaultStyle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.makeTransparent()
    }
    
    func setDelegates() {
        contactsManager.contactsData.delegate = self
    }
    
    func setupLeftMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    func setTableStyle() {
        tableView.backgroundColor = Constants.DefaultColor.background
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func registerNibs() {
        tableView.register(UINib(nibName: "ContactsCell", bundle: nil), forCellReuseIdentifier: "ContactsCell")
    }
    
    func updateUIWithLocalizedText() {
        
        navigationItem.title = "screen_contacts_title".localized()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsManager.getNumberOfTableCells()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath) as? ContactsCell
            else { return UITableViewCell() }
        
        cell.updateCellWith(contactsManager.getPersonFor(indexPath))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ShowProfile", sender: indexPath)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueID = segue.identifier else { return }
        
        switch segueID {
        case "ShowProfile":
            guard let indexPath = sender as? IndexPath else { return }
            let publicContactToShow = contactsManager.getPersonFor(indexPath)
            guard let destination = segue.destination as? ProfileVC else { return }
            destination.publicContactToShow = publicContactToShow
        default:
            print("Was used undefined segue")
        }
    }

}
