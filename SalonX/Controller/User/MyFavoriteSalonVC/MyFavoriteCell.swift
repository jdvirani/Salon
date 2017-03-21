//
//  MyFavoriteCell.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/18/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class MyFavoriteCell: UITableViewCell {

    @IBOutlet weak var Img_Salon: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Style: UILabel!
    @IBOutlet weak var lbl_Ratingview: TQStarRatingView!
    @IBOutlet weak var lbl_Review: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var btn_Favorite: UIButton!
    
    @IBOutlet weak var lbl_BottmBorder: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
