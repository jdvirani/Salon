//
//  HomeCell.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/20/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell,KIImagePagerDelegate,KIImagePagerDataSource {

//    MARK:- Home Header
    
    @IBOutlet weak var lbl_welcome: UILabel!
    @IBOutlet weak var image_Pager: KIImagePager!
    
//    MARK:- Home
    @IBOutlet weak var Img_Home: UIImageView!
    
    @IBOutlet weak var lbl_Title: UILabel!
    
    var sliderData:[String] = [String]()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    func setImagePagerConfigure(arraySlider:[String]) {
        
        image_Pager.indicatorDisabled = false
        image_Pager.imageCounterDisabled = true
        image_Pager.slideshowTimeInterval = UInt(3.5)
        image_Pager.slideshowShouldCallScrollToDelegate = true
        sliderData = arraySlider
        image_Pager.reloadData()
    }
    
    //    MARK:- KIImagePager DataSource
    func array(withImages pager: KIImagePager!) -> [Any]! {
        return sliderData
    }
    func contentMode(forImage image: UInt, in pager: KIImagePager!) -> UIViewContentMode {
        return UIViewContentMode.scaleAspectFill
    }
    func placeHolderImage(for pager: KIImagePager!) -> UIImage! {
        return UIImage(named: "placeholder_listing_salon")
    }
    
    //    MARK:- KIImagePager Delegate
    func imagePager(_ imagePager: KIImagePager!, didScrollTo index: UInt) {
        print("did scroll To Index:=\(index)")
    }
    func imagePager(_ imagePager: KIImagePager!, didSelectImageAt index: UInt) {
        print("did Select Image At Index:=\(index)")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
