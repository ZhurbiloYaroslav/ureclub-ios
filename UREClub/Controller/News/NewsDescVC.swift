//
//  NewsDescVC.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 19.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class NewsDescVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var currentNews: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultBackground()
        updateUIWithValues()
        updateUILabelsWithLocalizedText()
    }
    
    func updateUILabelsWithLocalizedText() {
        
        navigationItem.title = "screen_newsDescription_title".localized()
        
    }
    
    func updateUIWithValues() {
        guard let news = currentNews else {
            return
        }
        if news.imageLinks.count > 0 {
            imageView.downloadedFrom(link: news.imageLinks[0])
        }
        
        titleLabel.text = news.title
        dateLabel.text = news.date
        contentLabel.text = news.textContent
        
    }
    
}
