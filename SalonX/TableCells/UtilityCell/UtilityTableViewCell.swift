//
//  UtilityTableViewCell.swift
//  SalonX
//
//  Created by DK on 17/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class UtilityTableViewCell: UITableViewCell {

    @IBOutlet weak var viewUtility: UIView!
    @IBOutlet weak var txtUtilityName: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewUtility.addCornerAndBorderStyle()
        btnDelete.titleLabel?.font = UIFont.fontAwesome(ofSize: 22)
        btnDelete.tintColor = R.color.salonX.headerBG()
        btnDelete.setTitle("\(String.fontAwesomeIcon(name: .trashO))", for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
