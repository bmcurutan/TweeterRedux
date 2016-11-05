//
//  IconMenuCell.swift
//  Tweeter
//
//  Created by Bianca Curutan on 11/5/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class IconMenuCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // TODO (icon should be gray unselected, and tinted when selected)
    }

}
