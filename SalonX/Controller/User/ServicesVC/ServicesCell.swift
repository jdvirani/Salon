//
//  ServicesCell.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/23/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class ServicesCell: UITableViewCell {

    @IBOutlet weak var btn_Check: UIButton!
    
    @IBOutlet weak var lbl_ServiceName: UILabel!
    
    @IBOutlet weak var lbl_Count: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 3
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
