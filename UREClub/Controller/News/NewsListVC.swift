//
//  NewsListVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 09.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SWRevealViewController

extension NewsListVC: NetworkManagerDelegate {
    func didLoad(arrayWithNews: [News]) {
        self.arrayWithNews = getSortedNewsFrom(arrayWithNews)
        tableView.reloadData()
        presentNewsFromNotification()
    }
}

class NewsListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    public var dataFromNotification: DataFromPushNotification?
    
    private var arrayWithNews = [News]()
    private var networkManager = NetworkManager()
    
    private var newsFilter = Filter(withType: .news)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = Constants.DefaultColor.background
        self.setDefaultBackground()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        getArrayWithNews()
        setDelegates()
        registerNibs()
        setupLeftMenu()
        updateUIWithLocalizedText()
    }
    
    func getArrayWithNews() {
        let spinner = UIViewController.displaySpinner(onView: view)
        networkManager.retrieveInfoForPath(.news) { (errors) in
            UIViewController.removeSpinner(spinner: spinner)
        }
    }
    
    func presentNewsFromNotification() {
        if let data = dataFromNotification, data.isNews,
            let newsDescVC = ArticleDescVC.getInstance(),
            let currentNews = getNewsByPostID(data.postIDs) {
            newsDescVC.currentArticle = currentNews
            navigationController?.pushViewController(newsDescVC, animated: true)
        }
    }
    
    func getNewsByPostID(_ postIDs: [Int]) -> News? {
        var resultEvent: News? = nil
        arrayWithNews.forEach { news in
            if postIDs.contains(news.getPostID()) {
                resultEvent = news
            }
        }
        return resultEvent
    }
    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        networkManager.delegate = self
    }
    
    func registerNibs() {
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
    }
    
    func setupLeftMenu() {
        if revealViewController() != nil {
            
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    func updateUIWithLocalizedText() {
        
        navigationItem.title = "screen_news_title".localized()
        
    }
    
    func getSortedNewsFrom(_ newsArray: [News]) -> [News] {
        let newsSortedByDate = newsArray.sorted { news1, news2 in
            let news1Date = Formatter.getDateFrom(news1.getDate())
            let news2Date = Formatter.getDateFrom(news2.getDate())
            return news1Date > news2Date
        }
        return newsSortedByDate
    }
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        if let filterVC = FilterVC.getInstance() {
            filterVC.filterManager.currentFilter = newsFilter
            navigationController?.pushViewController(filterVC, animated: true)
        }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell
            else { return UITableViewCell() }
        let news = arrayWithNews[indexPath.row]
        cell.delegate = self
        cell.updateCellWith(news)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let articleDescVC = ArticleDescVC.getInstance() {
            articleDescVC.currentArticle = arrayWithNews[indexPath.row]
            navigationController?.pushViewController(articleDescVC, animated: true)
        }
        
    }
}

extension NewsListVC: NewsCellDelegate {
    func didPressReadMoreFor(_ news: News) {
        if let articleDescVC = ArticleDescVC.getInstance() {
            articleDescVC.currentArticle = news
            navigationController?.pushViewController(articleDescVC, animated: true)
        }
    }
}
