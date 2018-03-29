//
//  NewsCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 24.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SDWebImage

protocol NewsCellDelegate: class {
    func didPressReadMoreFor(_ news: News)
}

class NewsCell: UITableViewCell {
    
    weak var delegate: NewsCellDelegate?
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    var currentNews: News!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDefaultImage()
        
    }
    
    func setDefaultImage() {
        articleImage.image = #imageLiteral(resourceName: "image-placeHolder")
    }
    
    func updateCellWith(_ news: News) {
        
        self.currentNews = news
        
        titleLabel.text = news.title
        
        if news.imageLinks.count > 0 {
            articleImage.sd_setImage(with: URL(string: news.imageLinks[0]), placeholderImage: #imageLiteral(resourceName: "image-placeHolder"))
        }
        
        titleLabel.numberOfLines = 4
        dayLabel.text = news.getDayFromDate()
        monthLabel.text = news.getShirtStringWithMonthFromDate()
    }
    
    @IBAction func didPressReadMoreButton(_ sender: UIButton) {
        delegate?.didPressReadMoreFor(currentNews)
    }
    
}
