//
//  ArticleCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 20.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
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
        
        titleLabel.text = article.title
        if article.imageLinks.count > 0 {
            articleImage.downloadedFrom(link: article.imageLinks[0], contentMode: .scaleAspectFill)
        }
        
        if let eventEntity = article as? Event {
            
            dateLabel.text = eventEntity.date.getDate()
            timeLabel.text = eventEntity.date.getTimePeriod()
            addressLabel.text = eventEntity.place.getAddressAndCity()
            
        } else if let newsEntity = article as? News {
            
            dateLabel.text = newsEntity.date
            
            geoImage.isHidden = true
            timeLabel.isHidden = true
            addressLabel.isHidden = true
        }
    }
    
    enum ArticleType {
        case Event
        case News
        case Undefined
    }
}
