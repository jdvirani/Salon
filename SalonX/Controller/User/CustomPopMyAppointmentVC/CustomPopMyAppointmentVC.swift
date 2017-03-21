//
//  CustomPopMyAppointmentVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/24/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit


class CustomPopMyAppointmentVC: UIViewController {

    @IBOutlet weak var lbl_Message: UILabel!
    
    @IBOutlet weak var btn_Left: UIButton!
    
    @IBOutlet weak var btn_Right: UIButton!
    
    var IsFrom:String!
    var btnName:String!
    var Appointment:MyAppointmentVC!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        btn_Left.backgroundColor = UIColor.init(hexString: "#049FCF")
        
        if IsFrom == "Cancel" {
            lbl_Message.text = LocalizedString(key: "lbl_PopMyAppointment_CancelAppointment")
            btn_Left.setTitle(LocalizedString(key: "Comman_btn_Yes"), for: .normal)
            btn_Right.setTitle(LocalizedString(key: "Comman_btn_No"), for: .normal)
            btn_Right.backgroundColor = UIColor.init(hexString: "#353A45")
        }
        else if IsFrom == "Modify" {
            lbl_Message.text = LocalizedString(key: "lbl_PopMyAppointment_ModifyAppointment")
            btn_Left.setTitle(LocalizedString(key: "btn_PopMyAppointment_Service"), for: .normal)
            btn_Right.setTitle(LocalizedString(key: "btn_PopMyAppointment_Time"), for: .normal)
            btn_Right.backgroundColor = UIColor.init(hexString: "#049FCF")
        }
    }

    
//    MARK:- Button Action
    
    
    @IBAction func btn_LeftAction(_ sender: UIButton) {
        if IsFrom == "Cancel" {
//            btnName = "Yes"
            self.dismiss(animated: true, completion: nil)
            Appointment.DissmissCustomPopMyAppointment(sender: btnName)
        }
        else if IsFrom == "Modify" {
            
            btnName = "Service"
            self.dismiss(animated: true, completion: nil)
            Appointment.DissmissCustomPopMyAppointment(sender: btnName)
        }
        
    }
    
    @IBAction func btn_RightAction(_ sender: UIButton) {
        if IsFrom == "Cancel" {
            btnName = "No"
            self.dismiss(animated: true, completion: nil)
            Appointment.DissmissCustomPopMyAppointment(sender: btnName)
        }
        else {
            btnName = "Time"
            self.dismiss(animated: true, completion: nil)
            Appointment.DissmissCustomPopMyAppointment(sender: btnName)
        }
       
    }
    
    func custombuttonName(_ name:String) -> String! {
        return name
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

