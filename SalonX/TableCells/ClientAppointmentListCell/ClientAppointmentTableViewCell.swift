//
//  ClientAppointmentTableViewCell.swift
//  SalonX
//
//  Created by DK on 15/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class ClientAppointmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblEmployeeName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBG.borderWidth = 1.0
        viewBG.borderColor = R.color.salonX.headerBG()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
