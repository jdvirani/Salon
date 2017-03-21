//
//  ServiceHeaderTableViewCell.swift
//  SalonX
//
//  Created by DK on 16/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import FontAwesome_swift

class ServiceHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var btnEditGroup: UIButton!
    @IBOutlet weak var btnDeleteGroup: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        btnDeleteGroup.titleLabel?.font = UIFont.fontAwesome(ofSize: 20.0)
        btnDeleteGroup.setTitleColor(R.color.salonX.headerBG(), for: .normal)
        btnDeleteGroup.setTitle("\(String.fontAwesomeIcon(name: .trash))", for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
