//
//  TransparentTableViewCell.swift
//  OSFramework
//
//  Created by Daniel Vela on 29/04/2017.
//  Copyright © 2017 Daniel Vela. All rights reserved.
//

import UIKit

class TransparentTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
