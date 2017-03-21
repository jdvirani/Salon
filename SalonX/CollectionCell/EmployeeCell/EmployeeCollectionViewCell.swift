//
//  EmployeeCollectionViewCell.swift
//  SalonX
//
//  Created by DK on 15/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class EmployeeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgEmployee: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblratingView: TQStarRatingView!
    @IBOutlet weak var lblTotalReview: UILabel!
    @IBOutlet weak var lblSpecialist: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!

}
