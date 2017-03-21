//
//  CustomPopMyAppointmentFeedBackVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 3/16/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class CustomPopMyAppointmentFeedBackVC: UIViewController {

    @IBOutlet weak var lbl_Name: UILabel!
    
    @IBOutlet weak var btn_Save: UIButton!
    
    @IBOutlet weak var btn_Cancel: UIButton!
    
    @IBOutlet weak var txt_Comment: KMPlaceholderTextView!
    
    @IBOutlet var HCRateView: HCSStarRatingView!
    
    
    var ProfessionStyle:String!
    var ProfessionName:String!
    var Appointment:MyAppointmentVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setLocaliztionStaticText()
        ProfessionStyle.append(" By ")
        let attrs1 = [NSFontAttributeName : UIFont.init(name: "Helvetica", size: 14), NSForegroundColorAttributeName : UIColor.init(hexString: "#666666")]
        
        let attrs2 = [NSFontAttributeName : UIFont.init(name: "Helvetica-Bold", size: 14), NSForegroundColorAttributeName : UIColor.init(hexString: "#049FCF")]
        
//        let attrs3 = [NSFontAttributeName : UIFont.init(name: "Helvetica", size: 14), NSForegroundColorAttributeName : UIColor.init(hexString: "#2B2D2D")]
        
        let attributedString1 = NSMutableAttributedString(string:ProfessionStyle, attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string:ProfessionName, attributes:attrs2)
        
//        let attributedString3 = NSMutableAttributedString(string:"?", attributes:attrs3)
        
        attributedString1.append(attributedString2)
//        attributedString1.append(attributedString3)
        self.lbl_Name.attributedText = attributedString1
        

        
        HCRateView.addTarget(self, action: #selector(self.didChangeStarRating(_:)), for: .valueChanged)
    }
    
    
    
    @IBAction func btn_SaveAndCancelAction(_ sender: UIButton) {
        
        if sender.tag == 1 {
            // Save Click
            self.dismiss(animated: true, completion: nil)
            Appointment.dismissCustomStarRatingPop(sender: "Save")
        }
        else {
            // Cancel Click
            self.dismiss(animated: true, completion: nil)
            Appointment.dismissCustomStarRatingPop(sender: "Cancel")
        }
        
    }

//    MARK:- HCRateview Delegate
    func didChangeStarRating(_ sender:HCSStarRatingView) {
        print("HCssRatview:===\(sender.value)")
    }
    
    
//    MARK:- Custom function
    func setLocaliztionStaticText() {
        txt_Comment.placeholder = LocalizedString(key: "txtPlace_BookLastminOfferCell2_Comment")
        btn_Save.setTitle(LocalizedString(key: "Comman_btn_Save"), for: .normal)
        btn_Cancel.setTitle(LocalizedString(key: "Comman_btn_Cancel"), for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
