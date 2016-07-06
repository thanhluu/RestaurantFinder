//
//  RestaurantCell.swift
//  RestaurantFinder
//
//  Created by Luu Tien Thanh on 7/6/16.
//  Copyright © 2016 Thanh Luu. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    
    @IBOutlet weak var restaurantTitleLabel: UILabel!
    @IBOutlet weak var restaurantCheckinLabel: UILabel!
    @IBOutlet weak var restaurantCategoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
