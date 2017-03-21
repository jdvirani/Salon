//
//  ReportDetailTableViewCell.swift
//  SalonX
//
//  Created by DK on 20/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class ReportDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblFirstDetail: UILabel!
    @IBOutlet weak var lblSecondDetail: UILabel!
    @IBOutlet weak var lblThirdDetail: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
