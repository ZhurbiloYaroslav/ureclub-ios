//
//  NewsCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 24.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateCellWith(_ news: News) {
        newsImage.downloadedFrom(link: news.imageLinks[0])
        titleLabel.text = news.title
    }
}
