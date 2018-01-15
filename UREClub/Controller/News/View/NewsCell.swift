//
//  NewsCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 24.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SDWebImage

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDefaultImage()
    }
    
    func setDefaultImage() {
        newsImage.image = #imageLiteral(resourceName: "image-placeHolder")
    }
    
    func updateCellWith(_ news: News) {
        setDefaultImage()
        if news.imageLinks.count > 0 {
            newsImage.sd_setImage(with: URL(string: news.imageLinks[0]), placeholderImage: #imageLiteral(resourceName: "image-placeHolder"))
        }
        
        titleLabel.text = news.title
        dateLabel.text = news.date
    }
}
