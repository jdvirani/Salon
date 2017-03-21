//
//  ClientListTableViewCell.swift
//  SalonX
//
//  Created by DK on 11/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class ClientListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgClientPicture: UIImageView!
    @IBOutlet weak var lblClientName: UILabel!
    @IBOutlet weak var lblAppointmentCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        imgClientPicture.layer.cornerRadius = 5.0
        imgClientPicture.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
