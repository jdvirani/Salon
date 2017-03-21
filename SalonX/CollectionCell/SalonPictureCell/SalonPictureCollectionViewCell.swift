//
//  SalonPictureCollectionViewCell.swift
//  SalonX
//
//  Created by DK on 17/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class SalonPictureCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgSalonPicuture: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEditPlaceHolder: UIButton!
    
    func setCellUI() {
        imgSalonPicuture.layer.cornerRadius = 3.0
        imgSalonPicuture.clipsToBounds = true
    }
}
