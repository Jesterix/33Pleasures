//
//  StatsCell.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 10/08/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//

import UIKit

class StatsCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var wasSelectedLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
