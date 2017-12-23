//
//  NewsCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 24.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateCellWith(_ news: News) {
        newsImageView.downloadedFrom(link: news.imageLinks[0])
        newsTitleLabel.text = news.title
    }
}
