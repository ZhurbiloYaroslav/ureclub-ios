//
//  MembersVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SWRevealViewController

class MembersVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var tableViewCellCoordinator: [IndexPath: Int] = [:]
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = Constants.Color.skyLight
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        setDelegates()
        self.setDefaultBackground()
        setupLeftMenu()
        updateUILabelsWithLocalizedText()
    }
    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupLeftMenu() {
        if revealViewController() != nil {
            
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func updateUILabelsWithLocalizedText() {
        
        navigationItem.title = "screen_members_title".localized()
        
    }
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowFilter", sender: nil)
    }

}

extension MembersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0,6,12:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as? CompanyCell
                else { return UITableViewCell() }
            
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            
            let tag = 10000*(indexPath.section+1)+indexPath.row
            cell.collectionView.tag = tag
            tableViewCellCoordinator[indexPath] = tag
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonCell
                else { return UITableViewCell() }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CompanyCell else { return }
        cell.collectionView.reloadData()
        cell.collectionView.contentOffset = .zero
    }
}

extension MembersVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCollectionCell", for: indexPath) as? PersonCollectionCell
            else { return UICollectionViewCell() }
        cell.setRadius(25, withWidth: 1, andColor: UIColor.clear)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PersonCollectionCell
            else { return }
        cell.personImageView.sd_setImage(with: URL(string: CurrentUser.linkImage), placeholderImage: #imageLiteral(resourceName: "icon-user_circle"))
        //cell.label.text = "\(tableViewCellCoordinator.key(forValue: collectionView.tag)!) \(indexPath)"
    }
}
