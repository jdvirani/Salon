//
//  NotificationTableViewCell.swift
//  SalonX
//
//  Created by DK on 23/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var imgClientPicture: UIImageView!
    @IBOutlet weak var lblClientName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblNew: UILabel!
    @IBOutlet weak var viewSeperator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewSeperator.isHidden = true
        imgClientPicture.layer.cornerRadius = 3.0
        imgClientPicture.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
