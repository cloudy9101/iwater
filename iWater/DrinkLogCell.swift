//
//  DrinkLogCell.swift
//  iWater
//
//  Created by cloudy on 2018/5/26.
//  Copyright © 2018年 cloudy9101. All rights reserved.
//

import UIKit

class DrinkLogCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
