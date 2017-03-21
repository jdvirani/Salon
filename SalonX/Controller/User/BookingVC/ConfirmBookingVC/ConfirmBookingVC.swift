//
//  ConfirmBookingVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 3/4/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class ConfirmBookingVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblConfirmBooking: UITableView!
    
    var getResult:NSDictionary!
    var getBookingData:NSDictionary!
    var isDiscountEmpty:Bool = false
    var payAt:String!
    var isAcceptTC:Bool = false
    var SalonType:String!
    var SelectedTime:String!
    var SelectedDate:String!
    var SelectedEmployeID:String!
    var Is_first:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("getResult:===\(getResult)")
        print("getBookingData:===\(getBookingData)")
        payAt = "0"
        isDiscountEmpty = true
        
        self.navigationController?.navigationBar.isHidden = false
        setupBackButton()
        
        self.title = LocalizedString(key: "lbl_ConfirmBookingHeader")
        
        let BookingnibName = UINib(nibName: "ConfirmBookingCell", bundle: nil)
        tblConfirmBooking.register(BookingnibName, forCellReuseIdentifier: "ConfirmBookingCell")
        
        let lastMintOfferBookCell3Nib = UINib(nibName: "LastMintOfferBookCell3", bundle: nil)
        tblConfirmBooking.register(lastMintOfferBookCell3Nib, forCellReuseIdentifier: "LastMintOfferBookCell3")
        
    }

    //  MARK:- Tabelview Delegate & DataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cell for row")
        if indexPath.row == 0 {
            let cell = tblConfirmBooking.dequeueReusableCell(withIdentifier: "ConfirmBookingCell") as! ConfirmBookingCell
             cell.lbl_OtherBeautyStyle.text = getBookingData.value(forKey: "profession_name") as? String
            if let Img = getBookingData.value(forKey: "salon_image") as? String {
                cell.img_BeautyType.sd_setImage(with: URL.init(string: Img), placeholderImage: UIImage.init(named: "user_placeholder_salon_member"))
            }
            
            if isDiscountEmpty {
                cell.constantDiscountViewHeight.constant = 0
                cell.DiscountView.isHidden = true
            }
            if SalonType == "1" {
                cell.constantStaffViewHight.constant = 0
                cell.StaffView.isHidden = true
            }
            if let starcount = getBookingData.value(forKey: "rat_total") as? String {
                cell.lbl_StarCount.text = "(\(starcount))"
            }
            else {
                cell.lbl_StarCount.text = "(0)"
            }
            if let rate = getBookingData.value(forKey: "rat_avg") as? NSString {
                cell.StarView.setScore(Float(rate.floatValue/10), withAnimation: false)
            }
           cell.lbl_BeautyStyle.text = getBookingData.value(forKey: "salon_name") as? String
            
            cell.lbl_Date.text = getResult.value(forKey: "booking_date") as? String
            cell.lbl_Price.text = getResult.value(forKey: "price") as? String
            cell.lbl_Staff.text = getResult.value(forKey: "emp_name") as? String
            cell.lbl_Total.text = getResult.value(forKey: "pay_amount") as? String
            cell.lbl_Discount.text = "$2 Disacount(5%)"
            cell.lbl_Duration.text = getResult.value(forKey: "duration") as? String
            cell.lbl_Promocode.text = "A123"
            cell.lbl_BeautyName.text = getBookingData.value(forKey: "service_name") as? String
            
            
            return cell
        }
        else {
            
            let cell = tblConfirmBooking.dequeueReusableCell(withIdentifier: "LastMintOfferBookCell3") as! LastMintOfferCell
            cell.setLocalizedStaticTextForLastMintOfferBookCell3()
            cell.btn_PayVenyBook.tag = indexPath.row
            cell.btn_PayVenyBook.isSelected = true
            cell.btn_PayVenyBook.addTarget(self, action: #selector(self.btn_PayVenyBook(_:)), for: .touchUpInside)
            cell.btn_PayUBook.tag = indexPath.row
            cell.btn_PayUBook.addTarget(self, action: #selector(self.btn_PayUBook(_:)), for: .touchUpInside)
            cell.btn_AcceptBook.tag = indexPath.row
            cell.btn_AcceptBook.addTarget(self, action: #selector(self.btn_AcceptBook(_:)), for: .touchUpInside)
            cell.btn_FinishPaymentBook.tag = indexPath.row
            cell.btn_FinishPaymentBook.addTarget(self, action: #selector(self.btn_FinishPaymentBook(_:)), for: .touchUpInside)
            cell.lbl_DescriptionBook.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
            return cell
        }
        /* cell.btn_Favorite.tag = indexPath.row
         cell.btn_Favorite.addTarget(self, action: #selector(btn_FavoriteAction(_:)), for: .touchUpInside) */
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
//    MARK:- Custom Function
    
    func setLocaliztionStaticText() {
        self.title = LocalizedString(key: "lbl_ConfirmBookingHeader")
    }
    
    //    MARK:- Button Action
    func btn_PayVenyBook(_ sender: UIButton) {
        print("PayVeny Click")
        let Indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = tblConfirmBooking.cellForRow(at: Indexpath) as! LastMintOfferCell
        
        if cell.btn_PayVenyBook.isSelected {
            payAt = "1"
            cell.btn_PayVenyBook.isSelected = false
            if !(cell.btn_PayUBook.isSelected) {
                cell.btn_PayUBook.isSelected = true
            }
        }
        else {
            payAt = "0"
            cell.btn_PayVenyBook.isSelected = true
            if cell.btn_PayUBook.isSelected {
                cell.btn_PayUBook.isSelected = false
            }
        }
    }
    func btn_PayUBook(_ sender: UIButton) {
        print("PayU Click")
        let Indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = tblConfirmBooking.cellForRow(at: Indexpath) as! LastMintOfferCell
        
        if cell.btn_PayUBook.isSelected {
            payAt = "0"
            cell.btn_PayUBook.isSelected = false
            if !(cell.btn_PayVenyBook.isSelected) {
                cell.btn_PayVenyBook.isSelected = true
            }
        }
        else {
            payAt = "1"
            cell.btn_PayUBook.isSelected = true
            if cell.btn_PayVenyBook.isSelected {
                cell.btn_PayVenyBook.isSelected = false
            }
        }
    }
    func btn_AcceptBook(_ sender: UIButton) {
        print("Accept Click")
        let Indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = tblConfirmBooking.cellForRow(at: Indexpath) as! LastMintOfferCell
        
        if cell.btn_AcceptBook.isSelected {
            cell.btn_AcceptBook.isSelected = false
            isAcceptTC = false
        }
        else {
            isAcceptTC = true
            cell.btn_AcceptBook.isSelected = true
        }
    }
    func btn_FinishPaymentBook(_ sender: UIButton) {
        print("Finish Click")
        
//        lang [0 = Eng, 1 = romanian]
//        user_id
//        access_token
//        salon_id
//        offer_id [passed if book offer service]
//        service_id [passed if book service]
//        flag_view [0 = view service data, 1 = booking appointment ,2 = confirm booking]
       
//        [Only if flag_view = 1 or 2]
//        selected_time [passed if you passed service_id]
//        selected_date [passed if you passed service_id]
//        emp_id [if salon_type = 0]
//        message [Only if flag_view = 1]
//        promocode [passed promo code and not passed offer_id]
//        is_first [0 = no, 1 = yes]
//        pay_type [passed if flag_view = 2] [0 =pay at venue, 1 = pay with stripe]

        if payAt.isEmpty {
            BasicStuff.showAlert(title: ALERT_TITLE, message: "Please select payment method")
            return
        }
        else if !isAcceptTC {
            BasicStuff.showAlert(title: ALERT_TITLE, message: "Please accept term and condition")
            return
        }
        
        
        BasicStuff.showLoader(self.view)
        let getAccestokenwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("access_token")
        let getUserIDwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("user_id")
        
        let sendDict = NSMutableDictionary()
        sendDict.setValue(Language.shared.Lang, forKey: "lang")
        sendDict.setValue(getUserIDwithOutCredential, forKey: "user_id")
        sendDict.setValue(getAccestokenwithOutCredential, forKey: "access_token")
        sendDict.setValue(getBookingData.value(forKey: "salon_id") as! String, forKey: "salon_id")
        sendDict.setValue(getBookingData.value(forKey: "service_id") as! String, forKey: "service_id")
        sendDict.setValue(SelectedTime, forKey: "selected_time")
        sendDict.setValue(SelectedDate, forKey: "selected_date")
        
        if SalonType == "0" {
           sendDict.setValue(SelectedEmployeID, forKey: "emp_id")
        }

//        sendDict.setValue(txt_Promocode.text, forKey: "promocode")
//        sendDict.setValue(txtview_Comment.text, forKey: "message")
        sendDict.setValue(Is_first, forKey: "is_first")
        sendDict.setValue(payAt, forKey: "pay_type") //[0 =pay at venue, 1 = pay with stripe]
        sendDict.setValue("2", forKey: "flag_view") // 2 = confirm booking appointment
        
        SalonLog("sendDict:====>\(sendDict)")
        let manager = ServiceCall(URL: API_SalonBook_Appointment)
        manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
        manager.setContentType(contentType: .multiPartForm)
        
        manager.POST(parameters: sendDict) { (success, responceObj) in
            
            SalonLog("responceObj:====>\(responceObj)")
            
            if success {
                let Obj = responceObj as! NSDictionary
                let flag = Obj.value(forKey: "flag") as! NSNumber
                
                if flag == 1 {
                    let Appointment = MyAppointmentVC(nibName: "MyAppointmentVC", bundle: nil)
                    self.navigationController?.pushViewController(Appointment, animated: true)
                }
                else {
                    BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey: "msg") as! String)
                }
            }
            else {
                BasicStuff.showAlert(title: ALERT_TITLE, message: responceObj as! String)
            }
            
            BasicStuff.dismissLoader()
        }
    }
    
    func btn_BackAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
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
