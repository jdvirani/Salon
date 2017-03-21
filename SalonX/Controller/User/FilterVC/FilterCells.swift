//
//  FilterCells.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/21/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit
import MapKit
import DropDown

class FilterCells: UITableViewCell,MKMapViewDelegate {

    
//    MARK:- FilterCells
    @IBOutlet weak var txt_Location: UITextField!
    @IBOutlet weak var btn_Location: UIButton!
    @IBOutlet weak var txt_Date: UITextField!    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var rangerPrice: RangeSlider!
    
    @IBOutlet weak var lbl_StaticDate: UILabel!
    @IBOutlet weak var lbl_StaticLocation: UILabel!
    @IBOutlet weak var lbl_StaticPrice: UILabel!
    
    
//    MARK:- FilterMainCategory
    @IBOutlet weak var lbl_MainCategoryName: UILabel!
    
    
//    MARK:- FilterSubCategory
    @IBOutlet weak var btn_SubCategory: UIButton!
    
    @IBOutlet weak var lbl_SubCategoryName: UILabel!

    var LocationDD = DropDown()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setLocalizedStaticText() {
        lbl_StaticDate.text = LocalizedString(key: "lbl_FilterDate")
        lbl_StaticLocation.text = LocalizedString(key: "lbl_FilterLocation")
        lbl_StaticPrice.text = LocalizedString(key: "lbl_FilterPrice")
    }


    func setMapviewCustomLocationandPin() {
        
        let strLat = "21.221890"
        let strLon = "72.824131"
        let location = CLLocationCoordinate2D(
            latitude: Double(strLat)!,
            longitude: Double(strLon)!
        )
        
        var region: MKCoordinateRegion = self.mapView.region
        region.center.latitude = location.latitude
        region.center.longitude = location.longitude
        var span: MKCoordinateSpan = mapView.region.span
        span.latitudeDelta = 0.009
        span.longitudeDelta = 0.009
        region.span = span
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapView.centerCoordinate
        mapView.addAnnotation(annotation)
        mapView.delegate = self
    
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
    
    func configDropdown(dropdown: DropDown, sender: UIView) {
        print("btn_Location.width:=\(btn_Location.bounds.size.width)")
        dropdown.anchorView = sender
        dropdown.direction = .any
        dropdown.dismissMode = .onTap
        dropdown.bottomOffset = CGPoint(x: 0, y: sender.bounds.height)
        dropdown.width = UIScreen.main.bounds.size.width - 2
        dropdown.cellHeight = 40.0
        dropdown.backgroundColor = UIColor.white
    }
    
    func setSliderRange() {
        let range = Array(50...650)
        rangerPrice.setRangeValues(range)
//        rangerPrice.maxValueThumbTintColor = UIColor.darkGray
//        rangerPrice.minValueThumbTintColor = UIColor.darkGray
        
        
        rangerPrice.setValueChangedCallback { (minValue, maxValue) in
            print("rangeSlider1 min value:\(minValue)")
            print("rangeSlider1 max value:\(maxValue)")
        }
        rangerPrice.setMinValueDisplayTextGetter { (minValue) -> String? in
            return "$ \(minValue)"
        }
        rangerPrice.setMaxValueDisplayTextGetter { (maxValue) -> String? in
            return "$ \(maxValue)"
        }
    }
    
    func setConfigFiltersubCategoryRegularButtons() {
        btn_SubCategory.setImage(UIImage.init(named: "checkbox_unselect_regular"), for: .normal)
        btn_SubCategory.setImage(UIImage.init(named: "checkbox_select_regular"), for: .selected)
    }
    func setConfigFiltersubCategorySmallButton() {
        btn_SubCategory.setImage(UIImage.init(named: "checkbox_unselected_small"), for: .normal)
        btn_SubCategory.setImage(UIImage.init(named: "checkbox_selected_small"), for: .selected)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
