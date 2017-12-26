//
//  NewsListVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SWRevealViewController

class NewsListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var arrayWithNews = [News]()
    var networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = Constants.Color.skyLight
        self.setDefaultBackground()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        getArrayWithNews()
        setDelegates()
        registerNibs()
        setupLeftMenu()
    }
    
    func getArrayWithNews() {
        networkManager.retrieveInfoForPath(.news_all) { (errors) in
            print(errors)
        }
    }
    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        networkManager.delegate = self
    }
    
    func registerNibs() {
        tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
    }
    
    func setupLeftMenu() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowFilter", sender: nil)
    }

}

extension NewsListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayWithNews.count > 0 {
            return arrayWithNews.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell
            else { return UITableViewCell() }
        let news = arrayWithNews[indexPath.row]
        cell.updateCellWith(news)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowNewsDesc", sender: indexPath)
    }
}

extension NewsListVC: NetworkManagerDelegate {
    func didLoad(arrayWithNews: [News]) {
        self.arrayWithNews = arrayWithNews
        tableView.reloadData()
    }
}

//MARK: SEGUES
extension NewsListVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier else {
            return
        }
        
        switch segueID {
        case "ShowNewsDesc":
            guard let newsDescVC = segue.destination as? NewsDescVC else {
                return
            }
            if let indexPath = sender as? IndexPath {
                newsDescVC.currentNews = arrayWithNews[indexPath.row]
            }
            
        case "ShowFilter":
            break
        default:
            print("Was used undefined segue")
            return
        }
    }
}
