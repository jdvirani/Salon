//
//  MyAppointmentVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/24/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class MyAppointmentVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var TabView: UIView!
    @IBOutlet weak var btn_Upcoming: UIButton!
    @IBOutlet weak var btn_Latest: UIButton!
    
    @IBOutlet weak var tblMyAppointment: UITableView!
    
    var Offset:NSNumber = 0
    let refreshControl = UIRefreshControl()
    var AppointmentList = NSMutableArray()
    
    var SelectedData:NSDictionary!
    
    
    let getAccestokenwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("access_token")
    let getUserIDwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("user_id")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TabView.layer.borderWidth = 1
        TabView.layer.borderColor = UIColor.init(hexString: "#049FCF").cgColor
       
        
        
        let buttonMenu = UIBarButtonItem(image: UIImage(named: "ic_menubar_header"), style: .plain, target: self, action: #selector(self.btn_LeftMenuAction)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.leftBarButtonItem  = buttonMenu
        
//        self.title = "My Appointment"

        let buttonfilter = UIBarButtonItem(image: UIImage(named: "ic_filter_header"), style: .plain, target: self, action: #selector(self.btn_FilterAction(_:)))
        self.navigationItem.rightBarButtonItem = buttonfilter
        
        let AppointmentHeaderNibName = UINib(nibName: "MyAppointmentHeaderCell", bundle: nil)
        tblMyAppointment.register(AppointmentHeaderNibName, forCellReuseIdentifier: "MyAppointmentHeaderCell")
        
        let UpcomingCell = UINib(nibName: "MyAppointmentUpcomingCell", bundle: nil)
        tblMyAppointment.register(UpcomingCell, forCellReuseIdentifier: "MyAppointmentUpcomingCell")
        
        let UpcomingLastMinNibName = UINib(nibName: "MyAppointmentUpcomingLastMinCell", bundle: nil)
        
        tblMyAppointment.register(UpcomingLastMinNibName, forCellReuseIdentifier: "MyAppointmentUpcomingLastMinCell")
        
        tblMyAppointment.contentInset = UIEdgeInsetsMake(-14, 0, 0, 0)
        
        refreshControl.addTarget(self, action: #selector(self.refreshTable), for: .valueChanged)
        self.tblMyAppointment.bottomRefreshControl = refreshControl
        
         self.btn_ToggleAction(btn_Upcoming)
        
//        tblMyAppointment.register(UINib(nibName: "MyAppointmentHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "MyAppointmentHeaderView")
//        tblMyAppointment.reloadData()
//        self.refreshTable()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = LocalizedString(key: "lbl_MyAppointmentHeader")
        self.btn_Upcoming.setTitle(LocalizedString(key: "btn_MyAppointmentUpcoming"), for: .normal)
        self.btn_Latest.setTitle(LocalizedString(key: "btn_MyAppointmentLatest"), for: .normal)
    }
    
    func refreshTable(){
        refreshControl.beginRefreshing()
        self.getAppointmentList()
    }
    
//    MARK:- Custom Function
    func getAppointmentList() {
        
        if Offset.intValue >= 0 {
            
            BasicStuff.showLoader(self.view)
            
            let sendDict = NSMutableDictionary()
            sendDict.setValue(Language.shared.Lang, forKey: "lang")
            sendDict.setValue(Offset.stringValue, forKey: "offset")
            sendDict.setValue(getAccestokenwithOutCredential, forKey: "access_token")
            sendDict.setValue(getUserIDwithOutCredential, forKey: "user_id")
            if btn_Upcoming.isSelected == true {
                sendDict.setValue(String(btn_Upcoming.tag), forKey: "flag_view")
            }
            else {
                sendDict.setValue(String(btn_Latest.tag), forKey: "flag_view")
            }
            
            print("sendDict:===\(sendDict)")
            
            let manager = ServiceCall(URL: API_SalonMyAppointment)
            manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
            manager.setContentType(contentType: .multiPartForm)
            
            
            manager.POST(parameters: sendDict) { (success, responceObj) in
                
                SalonLog("responceObj:====>\(responceObj)")
                self.refreshControl.endRefreshing()
                
                if success {
                    let Obj = responceObj as! NSDictionary
                    let flag = Obj.value(forKey: "flag") as! NSNumber
                    if flag == 1 {
                        self.Offset = Obj.value(forKey: "next_offset") as! NSNumber
                        let arrayOffer = Obj.value(forKey: "data") as! NSArray
                        for r in 0..<arrayOffer.count {
                            let DicData = (arrayOffer[r] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            DicData.setValue("0", forKeyPath: "OurType")
                            self.AppointmentList.add(DicData)
                            let DataCopy = DicData.mutableCopy() as! NSMutableDictionary
                            DataCopy.setValue("1", forKey: "OurType")
                            self.AppointmentList.add(DataCopy)
                        }
                        print("AppointmentList:=\(self.AppointmentList)")
                        self.tblMyAppointment.reloadData()
                    }
                    else {
                        BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey: "msg") as! String)
                        self.AppointmentList.removeAllObjects()
                        self.tblMyAppointment.reloadData()
                    }
                }
                else {
                    BasicStuff.showAlert(title: ALERT_TITLE, message: responceObj as! String)
                }
                BasicStuff.dismissLoader()
            }
            
        }else {
            refreshControl.endRefreshing()
        }
    }
    
    func CancelUpcomingTabAppointment(AppointID:String) {
      
        BasicStuff.showLoader(self.view)
        
        let sendDict = NSMutableDictionary()
        sendDict.setValue(Language.shared.Lang, forKey: "lang")
//        sendDict.setValue(flag.stringValue, forKey: "offset")
        sendDict.setValue(getAccestokenwithOutCredential, forKey: "access_token")
        sendDict.setValue(getUserIDwithOutCredential, forKey: "user_id")
        sendDict.setValue("2", forKey: "flag_view") // 2 = cancel appointment
        sendDict.setValue(AppointID, forKey: "appointment_id")
        
        print("sendDict:===\(sendDict)")
        
        let manager = ServiceCall(URL: API_SalonMyAppointment)
        manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
        manager.setContentType(contentType: .multiPartForm)
        
        
        manager.POST(parameters: sendDict) { (success, responceObj) in
            
            SalonLog("responceObj:====>\(responceObj)")
            
            if success {
                let Obj = responceObj as! NSDictionary
                let flag = Obj.value(forKey: "flag") as! NSNumber
                if flag == 1 {
                    BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey: "msg") as! String)
                    for RemoveDic in self.AppointmentList {
                        print("RemoveDic:==\(RemoveDic)")
                        let dataDic = RemoveDic as! NSDictionary
                        if dataDic.value(forKey: "appointment_id") as! String == AppointID {
                            self.AppointmentList.remove(dataDic)
                        }
                    }
                    self.tblMyAppointment.reloadData()
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
    
    //    MARK:- Tableview Delegate & DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if btn_Latest.isSelected == true {
//            return 4
//        }
        return AppointmentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DicData = self.AppointmentList[indexPath.row] as! NSDictionary
        let ourtype = DicData.value(forKeyPath: "OurType") as! String
        
        if btn_Latest.isSelected == true {
            
           if ourtype == "0" {
                
                let cell = tblMyAppointment.dequeueReusableCell(withIdentifier: "MyAppointmentHeaderCell") as! MyAppointmentCells
                //            cell.Img_Header.image =
                cell.lbl_StarCount.text = "7\(indexPath.row)"
                cell.lbl_RateView.setScore(1, withAnimation: false)
                cell.lbl_StylishName.text = "Deon Layer"
                cell.lbl_Style.text = "Hair treatment"
                
                return cell
            }
            else  {
                
                let isLastMintOffer = DicData.value(forKey: "offer_id") as! String
                
                if isLastMintOffer == "0" {
                    let cell = tblMyAppointment.dequeueReusableCell(withIdentifier: "MyAppointmentUpcomingCell") as! MyAppointmentCells
                    
                    cell.lbl_UpStylishName.text = "Man's Hair cut"
                    cell.lbl_UpTime.text = "(20 Min)"
                    cell.lbl_UpPrice.text = "$ 50"
                    cell.lbl_UpDateTime.text = "/ 7 sep / 6 p.m."
                    
                    cell.btn_UpMessage.isHidden = true
                    //                cell.btn_UpMessage.accessibilityElements = [indexPath]
                    //                cell.btn_UpMessage.addTarget(self, action: #selector(self.btn_UpMessageAction(_:)), for: .touchUpInside)
                    
                    cell.btn_UpModify.accessibilityElements = [indexPath]
                    cell.btn_UpModify.addTarget(self, action: #selector(self.btn_UpModifyAction(_:)), for: .touchUpInside)
                    //                cell.btn_UpModify.setTitle("Reshedule", for: .normal)
                    
                    cell.btn_UpCancel.accessibilityElements = [indexPath]
                    cell.btn_UpCancel.addTarget(self, action: #selector(self.btn_UpCancelAction(_:)), for: .touchUpInside)
                    //                cell.btn_UpCancel.setTitle("Fedback", for: .normal)
                    
                    cell.btn_UpModify.setTitle(LocalizedString(key: "btn_MyAppointmentCell_Reshedule"), for: .normal)
                    cell.btn_UpCancel.setTitle(LocalizedString(key: "btn_MyAppointmentCell_Fedback"), for: .normal)
                    
                    return cell
                }
                else {
                    // this cell is Last Minute offer for Latest Tab
                    
                    let cell = tblMyAppointment.dequeueReusableCell(withIdentifier: "MyAppointmentUpcomingLastMinCell") as! MyAppointmentCells
                    
                    cell.lbl_UpLast_StylishName.text = "Man's Hair cut Short"
                    cell.lbl_UpLast_Time.text = "(20 Min)"
                    cell.lbl_UpLast_NewPrice.text = "$ 50"
                    cell.lbl_UpLast_OldPrice.text = "$ 70"
                    cell.lbl_UpLast_OldPrice.attributedText = BasicStuff.setStrikethroughStyleAttributeedText(cell.lbl_UpLast_OldPrice.text!)
                    cell.lbl_UpLast_ByName.text = "By John Dayer"
                    cell.lbl_UpLast_DateTime.text = "/ 7 sep / 6 p.m."
                    cell.btn_UpLast_Message.accessibilityElements = [indexPath]
                    cell.btn_UpLast_Message.addTarget(self, action: #selector(self.btn_UpLast_MessageAction(_:)), for: .touchUpInside)
                    //                cell.btn_UpLast_Message.setTitle("Fedback", for: .normal)
                    cell.btn_UpLast_Cancel.isHidden = true
                    cell.btn_UpLast_Message.setTitle(LocalizedString(key: "btn_MyAppointmentCell_Fedback"), for: .normal)
                    
                    //                cell.btn_UpLast_Cancel.accessibilityElements = [indexPath]
                    //                cell.btn_UpLast_Cancel.addTarget(self, action: #selector(self.btn_UpLast_CancelAction(_:)), for: .touchUpInside)
                    return cell
                }
            }
        }
        else {
            
            if ourtype == "0" {
                
                let cell = tblMyAppointment.dequeueReusableCell(withIdentifier: "MyAppointmentHeaderCell") as! MyAppointmentCells
                if let rate = DicData["rat_avg"] as? NSString {
                    let getFloat:Float = rate.floatValue/10
                    cell.lbl_RateView.setScore(getFloat, withAnimation: false)
                }
                else {
                    cell.lbl_RateView.setScore(0, withAnimation: false)
                }
                if let rateTotal = DicData["rat_total"] as? String {
                    cell.lbl_StarCount.text = "(\(rateTotal))"
                }else {
                    cell.lbl_StarCount.text = "(0)"
                }
                cell.lbl_Style.text = DicData.value(forKey: "profession_name") as? String
                cell.lbl_StylishName.text = DicData.value(forKey: "salon_name") as? String
                guard let SalonImg = DicData.value(forKey: "salon_image") as? String else {
                    return cell
                }
                cell.Img_Header.sd_setImage(with: URL.init(string: SalonImg), placeholderImage: UIImage.init(named: "placeholder_listing_salon"))
                return cell
            }
            else  {
                let isLastMintOffer = DicData.value(forKey: "offer_id") as! String
                
                if isLastMintOffer == "0" {
                    let cell = tblMyAppointment.dequeueReusableCell(withIdentifier: "MyAppointmentUpcomingCell") as! MyAppointmentCells
                    
                    cell.lbl_UpStylishName.text = DicData.value(forKey: "service_name") as? String
                    
                    cell.lbl_UpTime.text = "(\(DicData.value(forKey: "duration") as! String))"
                    cell.lbl_UpPrice.text = DicData.value(forKey: "price") as? String
                    cell.lbl_UpDateTime.text = "/ \(DicData.value(forKey: "appointment_date") as! String) / \(DicData.value(forKey: "start_time") as! String)."
                    cell.btn_UpMessage.isHidden = false
                    
                    cell.btn_UpModify.setTitle(LocalizedString(key: "btn_MyAppointmentCell_Modify"), for: .normal)
                    cell.btn_UpCancel.setTitle(LocalizedString(key: "btn_MyAppointmentCell_Cancel"), for: .normal)
                    
                    //                cell.btn_UpModify.setTitle("Modify", for: .normal)
                    //                cell.btn_UpCancel.setTitle("Cancel", for: .normal)
                    cell.btn_UpMessage.accessibilityElements = [indexPath]
                    cell.btn_UpMessage.addTarget(self, action: #selector(self.btn_UpMessageAction(_:)), for: .touchUpInside)
                    cell.btn_UpModify.accessibilityElements = [indexPath]
                    cell.btn_UpModify.addTarget(self, action: #selector(self.btn_UpModifyAction(_:)), for: .touchUpInside)
                    cell.btn_UpCancel.accessibilityElements = [indexPath]
                    cell.btn_UpCancel.addTarget(self, action: #selector(self.btn_UpCancelAction(_:)), for: .touchUpInside)
                    return cell
                }
                else {
                    // this cell contains Last Minute offer for Upcoming Tab
                    
                    let cell = tblMyAppointment.dequeueReusableCell(withIdentifier: "MyAppointmentUpcomingLastMinCell") as! MyAppointmentCells
                    
                    cell.lbl_UpLast_StylishName.text = "Man's Hair cut Short"
                    cell.lbl_UpLast_Time.text = "(20 Min)"
                    cell.lbl_UpLast_NewPrice.text = "$ 50"
                    cell.lbl_UpLast_OldPrice.text = "$ 70"
                    cell.lbl_UpLast_OldPrice.attributedText = BasicStuff.setStrikethroughStyleAttributeedText(cell.lbl_UpLast_OldPrice.text!)
                    cell.lbl_UpLast_ByName.text = "By John Dayer"
                    cell.lbl_UpLast_DateTime.text = "/ 7 sep / 6 p.m."
                    
                    cell.btn_UpLast_Message.accessibilityElements = [indexPath]
                    cell.btn_UpLast_Message.addTarget(self, action: #selector(self.btn_UpLast_MessageAction(_:)), for: .touchUpInside)
                    
                    cell.btn_UpLast_Cancel.isHidden = false
                    
                    cell.btn_UpLast_Cancel.accessibilityElements = [indexPath]
                    cell.btn_UpLast_Cancel.addTarget(self, action: #selector(self.btn_UpLastMint_CancelAction(_:)), for: .touchUpInside)
                    
                    //                cell.btn_UpLast_Message.setTitle("Message", for: .normal)
                    cell.btn_UpLast_Message.setTitle(LocalizedString(key: "btn_MyAppointmentCell_Message"), for: .normal)
                    cell.btn_UpLast_Cancel.setTitle(LocalizedString(key: "btn_MyAppointmentCell_Cancel"), for: .normal)
                    
                    return cell
                }
                
            }
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    

//    MARK:- Button Action
    
    @IBAction func btn_ToggleAction(_ sender: UIButton) {
        [btn_Upcoming,btn_Latest].forEach {$0?.isSelected = false
            $0?.backgroundColor = UIColor.white}
        Offset = 0
        if sender.tag == 0 {
            btn_Upcoming.isSelected = true
            btn_Upcoming.backgroundColor = UIColor.clear
        }
        else {
            btn_Latest.isSelected = true
            btn_Latest.backgroundColor = UIColor.clear
        }
        self.refreshTable()
    }
    
    func btn_FilterAction(_ sender:UIButton) {
        let filter = FilterVC(nibName: "FilterVC", bundle: nil)
        self.navigationController?.pushViewController(filter, animated: true)
    }
    
    func DissmissCustomPopMyAppointment(sender:String) {
        
        print("SelectedData:=\(SelectedData)")
        
        if sender == "UpcomingCancel" {
            print("Upcoming Cancel Appointment")
            self.CancelUpcomingTabAppointment(AppointID: SelectedData.value(forKey: "appointment_id") as! String)
        }
        else if sender == "UpcomingLastMintCancel" {
            print("Upcoming Cancel Last Mint Appointment")
        }
        else if sender == "Service" {
            print("Service change of this Appointment")
            let Service = ServicesVC(nibName: "ServicesVC", bundle: nil)
            self.navigationController?.pushViewController(Service, animated: true)
        }
        else if sender == "Time" {
            print("Time change of this Appointment")
            
            let Booking = BookingVC(nibName: "BookingVC", bundle: nil)
            Booking.salon_id = SelectedData.value(forKey: "salon_id") as! String
            Booking.service_id = SelectedData.value(forKey: "service_id") as! String
            Booking.salon_type = "0" // salon_type
            self.navigationController?.pushViewController(Booking, animated: true)
        }
        else
        {
            print("No")
        }
    }
    
    func dismissCustomStarRatingPop(sender: String) {
        
        if sender == "Save" {
            
        }
        else {
//            cancel
        }
    }
    
    
//    MARK:- UpComing And Latest Appointment Cell Button Action
    
    func btn_UpMessageAction(_ sender:UIButton) {
        let indexpath = sender.accessibilityElements?.first as! IndexPath
        let DataDicMesg = AppointmentList[indexpath.row] as! NSDictionary
        print("DataDicMesg:===\(DataDicMesg)")
        
//        let cell = tblMyAppointment.cellForRow(at: indexpath) as! MyAppointmentCells
        print("Upcoming Message click")    
        let Message = MessageVC(nibName: "MessageVC", bundle: nil)
        Message.salonId = DataDicMesg.value(forKey: "salon_id") as! String
        Message.appointmentID = DataDicMesg.value(forKey: "appointment_id") as! String
        self.navigationController?.pushViewController(Message, animated: true)
        
    }
    func btn_UpModifyAction(_ sender:UIButton) {
        let indexpath = sender.accessibilityElements?.first as! IndexPath
        SelectedData = AppointmentList[indexpath.row] as! NSDictionary
//        let cell = tblMyAppointment.cellForRow(at: indexpath) as! MyAppointmentCells
        if self.btn_Latest.isSelected == true {
            print("Latest Reshedule Click")
        }
        else {
            print("Upcoming Modify Click")
            let CustomPop = CustomPopMyAppointmentVC(nibName: "CustomPopMyAppointmentVC", bundle: nil)
            CustomPop.Appointment = self
            CustomPop.modalPresentationStyle = .overCurrentContext
            CustomPop.IsFrom = "Modify"
            //        CustomPop.btnName = "UpcomingModify"
            self.present(CustomPop, animated: true, completion: nil)
        }
        
    }
    
    func btn_UpCancelAction(_ sender:UIButton) {
        let indexpath = sender.accessibilityElements?.first as! IndexPath
        SelectedData = AppointmentList[indexpath.row] as! NSDictionary
//        let cell = tblMyAppointment.cellForRow(at: indexpath) as! MyAppointmentCells
        print("SelectedData:==>\(SelectedData)")
        if btn_Latest.isSelected == true {
            print("Latest Feedback Click")
            
            let CustomStarRatePop = CustomPopMyAppointmentFeedBackVC(nibName: "CustomPopMyAppointmentFeedBackVC", bundle: nil)
            CustomStarRatePop.Appointment = self
            CustomStarRatePop.ProfessionName = "Taykun Tang"
            CustomStarRatePop.ProfessionStyle = "Hair Style"
            CustomStarRatePop.modalPresentationStyle = .overCurrentContext
            self.present(CustomStarRatePop, animated: true, completion: nil)
            
        }
        else {
            print("Upcoming Cancel Click")
           
            let CustomPop = CustomPopMyAppointmentVC(nibName: "CustomPopMyAppointmentVC", bundle: nil)
            CustomPop.Appointment = self
            CustomPop.modalPresentationStyle = .overCurrentContext
            CustomPop.IsFrom = "Cancel"
            CustomPop.btnName = "UpcomingCancel"
            self.present(CustomPop, animated: true, completion: nil)
        }
        
        
    }
    
    func btn_UpLast_MessageAction(_ sender:UIButton) {
        let indexpath = sender.accessibilityElements?.first as! IndexPath
        let cell = tblMyAppointment.cellForRow(at: indexpath) as! MyAppointmentCells
        
        if btn_Latest.isSelected == true {
            print("Latest Last mint Fedback Click")
        }
        else {
            print("UpComoing Last mint Message Click")
            let Message = MessageVC(nibName: "MessageVC", bundle: nil)
            self.navigationController?.pushViewController(Message, animated: true)
        }
        
        
        
    }
    
    func btn_UpLastMint_CancelAction(_ sender:UIButton) {
        let indexpath = sender.accessibilityElements?.first as! IndexPath
        let cell = tblMyAppointment.cellForRow(at: indexpath) as! MyAppointmentCells
        
        print("Upcoming Last mint Cancel Click")
        let CustomPop = CustomPopMyAppointmentVC(nibName: "CustomPopMyAppointmentVC", bundle: nil)
        CustomPop.Appointment = self
        CustomPop.modalPresentationStyle = .overCurrentContext
        CustomPop.IsFrom = "Cancel"
        CustomPop.btnName = "UpcomingLastMintCancel"
        self.present(CustomPop, animated: true, completion: nil)
        
    }
    
    
   

    
    
    
    
//    func btn_UpLast_CancelAction(_ sender:UIButton) {
//        let indexpath = sender.accessibilityElements?.first as! IndexPath
//        let cell = tblMyAppointment.cellForRow(at: indexpath) as! MyAppointmentCells
//        
//    }
    
    
    
    //   MARK:- LeftMenu Action
    func btn_LeftMenuAction(_ sender: UIButton) {
        let sideMenuController = slideMenuController()
        sideMenuController?.openLeft()
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
