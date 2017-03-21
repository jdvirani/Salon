//
//  SalonDetailCells.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/22/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit
import MapKit

class SalonDetailCells: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,MKMapViewDelegate {

//    MARK:- SalonDetail Service
    @IBOutlet weak var lbl_StylishName: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var btn_BookNow: UIButton!
    @IBOutlet weak var lbl_Description: UILabel!
    
//    MARK:- SalonDetail Reviews
    
    @IBOutlet weak var Img_PersonReview: UIImageView!
    @IBOutlet weak var lbl_NameReivew: UILabel!
    @IBOutlet weak var lbl_StyleReivew: UILabel!
    @IBOutlet weak var lbl_StarViewReivew: TQStarRatingView!
    @IBOutlet weak var lbl_DaysReivew: UILabel!
    @IBOutlet weak var lbl_DescriptionReivew: UILabel!
    //@IBOutlet weak var lbl_BorderReivew: UILabel!
    
//    MARK:- SalonDetailInfoDescriptionCell
    
    @IBOutlet weak var lbl_InfoDescription: UILabel!
    @IBOutlet weak var btn_InfoViewMore: UIButton!
    
//    MARK:- SalonDetailInfoProgramCell
    
    @IBOutlet weak var lbl_ProgramDays: UILabel!
    @IBOutlet weak var lbl_ProgramTimes: UILabel!
    
//    MARK:-SalonDetailInfoHeaderCell
    
    @IBOutlet weak var lbl_InfoHeader: UILabel!
    //@IBOutlet weak var lbl_InfoHeaderBorder: UILabel!
    
//    MARK:- SalonDetailInfoLocationCell
    
    @IBOutlet weak var lbl_InfoLocationAddress: UILabel!
    @IBOutlet weak var MapView_InfoLocation: MKMapView!
    
//    MARK:- SalonDetailInfoUtilityCell
    
    @IBOutlet weak var lbl_InfoUtilityName: UILabel!
    
//    MARK:- SalonDetailInfoSocialCell
    
    @IBOutlet weak var btn_InfoSocialFB: UIButton!
    @IBOutlet weak var btn_InfoSocialTwitter: UIButton!
    @IBOutlet weak var btn_InfoSocialGPluse: UIButton!
    @IBOutlet weak var btn_InfoSocialPinteres: UIButton!
    @IBOutlet weak var btn_InfoSocialInsta: UIButton!
    @IBOutlet weak var btn_InfoSocialYoutube: UIButton!
   
//    MARK:- SalonDetailInfoTeamCell
    
    @IBOutlet weak var CollectionView_InfoTeam: UICollectionView!
    var SalonEmployee = NSArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setLocalizedStaticText() {
        
        
    }
    
    func setMapviewCustomLocationandPininSalonDetailInfo(strLat:String,strLon:String) {
        
        var strLat1 = "0.00"
        var strLon2 = "0.00"
        if (strLat.isEmpty) {
           
        }
        else if strLon.isEmpty {
            
        }
        else if (strLat.isEmpty) && (strLon.isEmpty) {
            
        }
        else {
            strLat1 = strLat
            strLon2 = strLon
        }
        
        let location = CLLocationCoordinate2D(
            latitude: Double(strLat1)!,
            longitude: Double(strLon2)!
        )
        
        var region: MKCoordinateRegion = self.MapView_InfoLocation.region
        region.center.latitude = location.latitude
        region.center.longitude = location.longitude
        var span: MKCoordinateSpan = MapView_InfoLocation.region.span
        span.latitudeDelta = 0.009
        span.longitudeDelta = 0.009
        region.span = span
        MapView_InfoLocation.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = MapView_InfoLocation.centerCoordinate
        MapView_InfoLocation.addAnnotation(annotation)
        MapView_InfoLocation.delegate = self
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "map_pin_blue")
        }
        
        return annotationView
    }
    
    func setBorderToSocialButton() {
        
        [btn_InfoSocialTwitter,btn_InfoSocialYoutube,btn_InfoSocialPinteres,btn_InfoSocialGPluse,btn_InfoSocialInsta,btn_InfoSocialFB].forEach({$0?.layer.borderWidth = 1
        $0?.layer.borderColor = UIColor.lightGray.cgColor})
    }
    
    func setCollectionviewData(Employee:NSArray)  {
        CollectionView_InfoTeam.delegate = self
        CollectionView_InfoTeam.dataSource = self
        let nibName = UINib(nibName: "SalonDetailInfoTeamCollectionCell", bundle: nil)
        CollectionView_InfoTeam.register(nibName, forCellWithReuseIdentifier: "SalonDetailInfoTeamCollectionCell")
        SalonEmployee = Employee
        CollectionView_InfoTeam.reloadData()
    }
//    MARK:- CollectionView Delegate And DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SalonEmployee.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionView_InfoTeam.dequeueReusableCell(withReuseIdentifier: "SalonDetailInfoTeamCollectionCell", for: indexPath) as! SalonDetailInfoTeamCell
        let DicData = SalonEmployee[indexPath.row] as! NSDictionary
        if let profile_pic = DicData.value(forKey: "profile_pic") as? String {
            cell.Img_Team.sd_setImage(with: URL.init(string: profile_pic), placeholderImage: UIImage.init(named: "user_placeholder_side_menu"))
        }
        cell.lbl_Style.text = DicData.value(forKeyPath: "speciality") as? String
        cell.lbl_TeamName.text = DicData.value(forKeyPath: "employee_name") as? String
        if let countStar = DicData.value(forKeyPath: "rat_count") as? String
        {
            cell.lbl_StarCount.text = "(\(countStar))"
        }
        else {
            cell.lbl_StarCount.text = "(0)"
        }
        if let countRate = DicData.value(forKeyPath: "rat_avg") as? NSString
        {
            cell.lbl_RateView.setScore(Float(countRate.floatValue/10), withAnimation: false)
        }
        else {
            cell.lbl_RateView.setScore(0, withAnimation: false)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


class SalonDetailInfoTeamCell: UICollectionViewCell {
    
    @IBOutlet weak var Img_Team : UIImageView!
    @IBOutlet weak var lbl_TeamName : UILabel!
    @IBOutlet weak var lbl_Style : UILabel!
    @IBOutlet weak var lbl_StarCount : UILabel!
    @IBOutlet weak var lbl_RateView: TQStarRatingView!
    
    
}
