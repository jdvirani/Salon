//
//  PreviewMessageTableViewCell.swift
//  SalonX
//
//  Created by DK on 21/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class PreviewMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
