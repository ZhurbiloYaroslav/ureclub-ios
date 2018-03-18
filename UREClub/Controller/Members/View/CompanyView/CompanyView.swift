//
//  CompanyView.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 17.03.18.
//  Copyright © 2018 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

protocol CompanyViewDelegate: class {
    func wasOpenedSection(_ section: Int)
    func wasClosedSection(_ section: Int)
}

class CompanyView: UIView {
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    public weak var delegate: CompanyViewDelegate?
    public var isOpened: Bool = false
    
    private var section: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.backgroundColor = Constants.Color.skyLight
        collectionView.setRadius(15, withWidth: 1, andColor: UIColor.clear)
        registerNibs()
    }
    
    func registerNibs() {
        let collectionCellNib = UINib(nibName: "PersonCollectionCell", bundle: nil)
        collectionView.register(collectionCellNib, forCellWithReuseIdentifier: "PersonCollectionCell")
    }
    
    func updateWith(_ company: Company, section: Int, isOpen: Bool?) {
        self.isOpened = isOpen ?? false
        self.section = section
        collectionView.tag = section
        checkVisibilityOfCollectionView()
        companyNameLabel.text = company.name
        companyImageView.sd_setImage(with: URL(string: company.getImageLink()), placeholderImage: #imageLiteral(resourceName: "placeholder-company"))
    }
    
    func checkVisibilityOfCollectionView() {
        collectionView.isHidden = isOpened
    }
    
    @IBAction func didTapOnView(_ sender: UITapGestureRecognizer) {
        if isOpened {
            isOpened = false
            delegate?.wasClosedSection(section)
        } else {
            isOpened = true
            delegate?.wasOpenedSection(section)
        }
    }

}
