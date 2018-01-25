//
//  ArticleCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleCell: UITableViewCell {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var timeStack: UIStackView!
    @IBOutlet weak var addressStack: UIStackView!
    @IBOutlet weak var geoImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var articleType: ArticleType = .Undefined
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDefaultImage()
    }
    
    func setDefaultImage() {
        articleImage.image = #imageLiteral(resourceName: "image-placeHolder")
    }
    
    func updateCellWith(_ article: Article) {
        
        titleLabel.numberOfLines = 3
        titleLabel.text = article.title
        
        if article.imageLinks.count > 0 {
            articleImage.sd_setImage(with: URL(string: article.imageLinks[0]), placeholderImage: #imageLiteral(resourceName: "image-placeHolder"))
        }
        
        if let eventEntity = article as? Event {
            
            dateLabel.text = eventEntity.date.getStringWithDate()
            timeLabel.text = eventEntity.date.getTimePeriod()
            addressLabel.text = eventEntity.location.getNameAndCity()
            
        } else if let newsEntity = article as? News {
            
            titleLabel.numberOfLines = 4
            dateLabel.text = newsEntity.getDate()
            
            timeStack.isHidden = true
            addressStack.isHidden = true
        }
    }
    
    enum ArticleType {
        case Event
        case News
        case Undefined
    }
}
