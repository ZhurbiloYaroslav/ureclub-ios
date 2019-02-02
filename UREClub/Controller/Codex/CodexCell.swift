//
//  CodexCell.swift
//  UREClub
//
//  Created by Yaroslav Zhurbilo on 14.12.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit

class CodexCell: UITableViewCell {
    
    @IBOutlet weak var codexItemTextLabel: UILabel!
    
    func updateCellWith(_ indexPath: IndexPath) {
        codexItemTextLabel.text = Codex().items[indexPath.row].localized()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = Constants.DefaultColor.background
    }
    
}
