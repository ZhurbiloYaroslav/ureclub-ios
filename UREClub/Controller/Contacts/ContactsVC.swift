//
//  ContactsVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SWRevealViewController

class ContactsVC: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var membersManager = MembersManager()
    var membersFilter = Filter(withType: .members)
    
    let person = Person(firstName: "Olga", lastName: "Solovei", company: Company(name: "UREClub", id: "1", type: "company", imageLink: "https://www.edukation.com.ua/upload_page/705/untitled_1_1453563195.jpg"), position: "Director", dateSince: "01.01.2013", id: "1", type: "member", imageLink: "https://media.licdn.com/media/AAEAAQAAAAAAAAMIAAAAJDg3NzU5NjA5LWVmMmMtNDE1NC1hNzNhLTI2NzkzZTgyYjZlMA.jpg")

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setDefaultBackground()
        setupLeftMenu()
        registerNibs()
        updateUILabelsWithLocalizedText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setDefaultStyle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.makeTransparent()
    }
    
    func setupLeftMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    func registerNibs() {
        tableView.register(UINib(nibName: "ContactsCell", bundle: nil), forCellReuseIdentifier: "ContactsCell")
    }
    
    func updateUILabelsWithLocalizedText() {
        
        navigationItem.title = "screen_contacts_title".localized()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath) as? ContactsCell
            else { return UITableViewCell() }
        
        cell.updateCellWith(person)
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
            let publicContactToShow = person
            guard let destination = segue.destination as? ProfileVC else { return }
            destination.publicContactToShow = publicContactToShow
        default:
            print("Was used undefined segue")
        }
    }

}
