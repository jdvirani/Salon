//
//  EmployeeReportDetailTableViewCell.swift
//  SalonX
//
//  Created by DK on 20/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class EmployeeReportDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSelfCreated : UILabel!
    @IBOutlet weak var lblSalonX: UILabel!
    @IBOutlet weak var lblLastMinute: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    var isTitle = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if isTitle {
            
            lblName.font = UIFont(name: "Helvetica-Regular", size: 14.0)
            lblSelfCreated.font = UIFont(name: "Helvetica-Regular", size: 14.0)
            lblSalonX.font = UIFont(name: "Helvetica-Regular", size: 14.0)
            lblLastMinute.font = UIFont(name: "Helvetica-Regular", size: 14.0)
            lblTotal.font = UIFont(name: "Helvetica-Regular", size: 14.0)
            lblTotal.textColor = R.color.salonX.fontDark()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
