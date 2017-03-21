//
//  BookingVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/22/17.
//  Copyright © 2017 dignizant. All rights reserved.
//
//ASJCollectionViewFillLayoutDelegate
import UIKit
import DropDown

class BookingVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,TimePickerDelegate {

    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var lbl_Duration: UILabel!
    @IBOutlet weak var Img_SalonType: UIImageView!
    @IBOutlet weak var lbl_BookType: UILabel!
    @IBOutlet weak var lbl_SalonType: UILabel!
    @IBOutlet weak var btn_YesBook: UIButton!
    @IBOutlet weak var btn_NoBook: UIButton!
    
    @IBOutlet weak var lbl_StarCount: UILabel!
    @IBOutlet weak var StarView: TQStarRatingView!
    @IBOutlet weak var lbl_OtherSalonType: UILabel!
    
    @IBOutlet weak var lbl_Date: UILabel!
    
    @IBOutlet var lbl_Days:Array<UILabel>!
    
    @IBOutlet var lbl_DateDays:Array<UILabel>!
    
    @IBOutlet var BGDayViews:Array<UIView>!
    
    @IBOutlet weak var lbl_StaticPromocode: UILabel!
    @IBOutlet weak var txt_Promocode: UITextField!

    @IBOutlet weak var txtview_Comment: KMPlaceholderTextView!
    
    @IBOutlet weak var lbl_BookSureText: UILabel!

    @IBOutlet weak var lbl_StaticYes: UILabel!
    @IBOutlet weak var lbl_StaticNo: UILabel!
    
    @IBOutlet weak var btn_FinishPayment: UIButton!
    
    @IBOutlet weak var DateMessageView: UIView!
    
    @IBOutlet weak var DateMessageView_lblTitle: UILabel!
    
    @IBOutlet weak var DateMessageView_lblMessage: UILabel!
    
    @IBOutlet weak var DateMessageView_btnCancel: UIButton!
    
    @IBOutlet weak var DateMessageView_btnOk: UIButton!
    
    @IBOutlet weak var constantStaffViewHeight: NSLayoutConstraint! //48
    @IBOutlet weak var constantCollectionviewHeight: NSLayoutConstraint! // 43
    @IBOutlet weak var CollectionObj: UICollectionView!
    var itemsPerRow: CGFloat = 4
    var sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    @IBOutlet weak var btn_StaffDD: UIButton!
    var StaffDD = DropDown()
    var EmployeeList = NSArray()
    var SelectedEmployeID = String()
    
    var TimeSlot = [String]()

    var service_id:String = String()
    var salon_id:String = String()
    var salon_type:String = String()
    
    let getAccestokenwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("access_token")
    let getUserIDwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("user_id")
    
    let datePicker = TimePickerViewController()
    var SelectedDate = String()
    var dateFormetter = DateFormatter()
    var TotalDays = [String]()
    var TotalDates = [String]()
    var FirstIndexOfDay:Int = Int()
    var SetFirstDate = Date()
    var SelectedTime = String()
    var program = [String]()
    var Is_first = String()
    var ResponceDataOfBookingDetail:NSDictionary!
    
    
//    MARK:- Viewcontroller Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.DateMessageView.isHidden = true
        if UIScreen.main.bounds.width == 320.0 {
            itemsPerRow = 3
        }
        self.navigationController?.navigationBar.isHidden = false
        setupBackButton()
        self.StarView.setScore(0, withAnimation: false)
        
        datePicker.timePickerDelegate = self
        datePicker.controlType = .datePicker
        datePicker.datePickerMode = .dateAndTime
        
        if let TodayDate = datePicker.timePicker?.date {
            print("TodayDate:=\(TodayDate)")
            self.lbl_Date.text = BasicStuff.convertDateToMonthAndYear(strDate: TodayDate)
            let getDateArray = String.init(describing: TodayDate).components(separatedBy: " ")
            
            SelectedDate = getDateArray[0]
            print("SelectedDate:=\(SelectedDate)")
        }
        
        if salon_type == "0" {
            
        }
        else {
            constantStaffViewHeight.constant = 0 // For Individual...
        }
        
        self.lbl_Duration.text = ""
        self.lbl_Price.text = ""
        self.lbl_SalonType.text = ""
        self.lbl_BookType.text = "k"
        self.lbl_OtherSalonType.text = ""
        
        let BookingTimeSlotCellNib = UINib(nibName: "BookingTimeSlotCell", bundle: nil)
        CollectionObj.register(BookingTimeSlotCellNib, forCellWithReuseIdentifier: "BookingTimeSlotCell")
        CollectionObj.reloadData()
        
        self.configDropdown(dropdown: StaffDD, sender: btn_StaffDD)
        
        
        
        self.getAppointmentBookingDetail()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLocaliztionStaticText()
        CollectionObj.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions(), context: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CollectionObj.removeObserver(self, forKeyPath: "contentSize")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is UICollectionView {
            constantCollectionviewHeight.constant = CollectionObj.contentSize.height
        }
    }
    
    
    

//    MARK:- Collectionview Delegate & Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.TimeSlot.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionObj.dequeueReusableCell(withReuseIdentifier: "BookingTimeSlotCell", for: indexPath) as! BookingTimeSlotCell
        cell.btnTime.setTitle(TimeSlot[indexPath.row], for: .normal)
        cell.btnTime.tag = indexPath.row
        cell.btnTime.backgroundColor = UIColor.init(hexString: "#37ADD7")
        SelectedTime = ""
//        cell.btnTime.accessibilityElements = [indexPath]
//        cell.btnTime.addTarget(self, action: #selector(self.btnTimeSlotAction(_:)), for: .touchUpInside)
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = CollectionObj.cellForItem(at: indexPath) as! BookingTimeSlotCell
        SelectedTime = TimeSlot[indexPath.row]
//            CollectionObj.dequeueReusableCell(withReuseIdentifier: "BookingTimeSlotCell", for: indexPath) as! BookingTimeSlotCell
        
        cell.btnTime.backgroundColor = UIColor.init(hexString: "#A4A4A4")
    }
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = CollectionObj.cellForItem(at: indexPath) as! BookingTimeSlotCell
//            CollectionObj.dequeueReusableCell(withReuseIdentifier: "BookingTimeSlotCell", for: indexPath) as! BookingTimeSlotCell
        cell.btnTime.backgroundColor = UIColor.init(hexString: "#37ADD7")
    }
    
//    MARK:- Custom Function
    func configDropdown(dropdown: DropDown, sender: UIView) {
        print("btn_Location.width:=\(btn_StaffDD.bounds.size.width)")
        dropdown.anchorView = sender
        dropdown.direction = .any
        dropdown.dismissMode = .onTap
        dropdown.bottomOffset = CGPoint(x: 0, y: sender.bounds.height)
        dropdown.width = btn_StaffDD.bounds.size.width
        dropdown.cellHeight = 40.0
        dropdown.backgroundColor = UIColor.white
    }
    
    func getAppointmentBookingDetail() {
        
//        offer_id [passed if book offer service]
//        service_id [passed if book service]
//        flag_view [0 = view service data, 1 = booking appointment]
       
        BasicStuff.showLoader(self.view)
        
        let sendDict = NSMutableDictionary()
        sendDict.setValue(Language.shared.Lang, forKey: "lang")
        sendDict.setValue(getUserIDwithOutCredential, forKey: "user_id")
        sendDict.setValue(getAccestokenwithOutCredential, forKey: "access_token")
        sendDict.setValue(salon_id, forKey: "salon_id")
//        sendDict.setValue(Language.shared.Lang, forKey: "offer_id")
        sendDict.setValue(service_id, forKey: "service_id")
        sendDict.setValue("0", forKey: "flag_view") // 0 = view service data
        SalonLog("sendDict:====>\(sendDict)")
        let manager = ServiceCall(URL: API_SalonBook_Appointment)
        manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
        manager.setContentType(contentType: .multiPartForm)
        
        manager.POST(parameters: sendDict) { (success, responceObj) in
            
            SalonLog("responceObj:====>\(responceObj)")
            BasicStuff.dismissLoader()
            if success {
                let Obj = responceObj as! NSDictionary
                let flag = Obj.value(forKey: "flag") as! NSNumber
                
                if flag == 1 {
                    let dicData = Obj.value(forKey: "data") as! NSDictionary
                    self.ResponceDataOfBookingDetail = dicData
                    self.lbl_Price.text = dicData.value(forKey: "price") as? String
                    if let img = dicData.value(forKey: "salon_image") as? String {
                        self.Img_SalonType.sd_setImage(with:URL.init(string: img) , placeholderImage: UIImage.init(named: "user_placeholder_side_menu"))
                    }
                    self.lbl_Duration.text = "(\(dicData.value(forKey: "duration") as! String))"
                    
                    self.lbl_OtherSalonType.text = dicData.value(forKey: "profession_name") as? String
                    
                    if let starcount = dicData.value(forKey: "rat_total") as? String {
                        self.lbl_StarCount.text = "(\(starcount))"
                    }
                    else {
                        self.lbl_StarCount.text = "(0)"
                    }
                    if let rate = dicData.value(forKey: "rat_avg") as? NSString {
                        self.StarView.setScore(Float(rate.floatValue/10), withAnimation: false)
                    }
                    self.lbl_BookType.text = dicData.value(forKey: "service_name") as? String
                    self.lbl_SalonType.text = dicData.value(forKey: "salon_name") as? String
                    var SalonName = String()
                    if let SalonName1 = self.lbl_SalonType.text {
                        SalonName = SalonName1
                    }
                    let attrs1 = [NSFontAttributeName : UIFont.init(name: "Helvetica", size: 14), NSForegroundColorAttributeName : UIColor.init(hexString: "#2B2D2D")]
                    
                    let attrs2 = [NSFontAttributeName : UIFont.init(name: "Helvetica-Bold", size: 14), NSForegroundColorAttributeName : UIColor.init(hexString: "#2B2D2D")]
                    
                    let attrs3 = [NSFontAttributeName : UIFont.init(name: "Helvetica", size: 14), NSForegroundColorAttributeName : UIColor.init(hexString: "#2B2D2D")]
                    
                    let attributedString1 = NSMutableAttributedString(string:LocalizedString(key: "lbl_BookLastminOfferCell2_SuareTextBook"), attributes:attrs1)
                    
                    let attributedString2 = NSMutableAttributedString(string:" \(SalonName) ", attributes:attrs2)
                    
                    let attributedString3 = NSMutableAttributedString(string:"?", attributes:attrs3)
                    
                    attributedString1.append(attributedString2)
                    attributedString1.append(attributedString3)
                    self.lbl_BookSureText.attributedText = attributedString1
                    
                    let program = dicData.value(forKey: "program") as? NSArray
                    if program?.count != 0 && program != nil {
                       var setDays = [String]()
                        for c in 0..<program!.count {
                            setDays.append((program![c] as! NSDictionary).value(forKey: "day_name") as! String)
                        }
                        self.program = setDays
                        self.MakeDays(DicData: setDays)
                    }
                    
                    if self.salon_type == "0" {
                       self.getEmployListforAppointment()
                    }
                }
                else {
                   BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey: "msg") as! String)
                    if self.salon_type == "0" {
                        self.getEmployListforAppointment()
                    }
                }
            }
            else {
                BasicStuff.showAlert(title: ALERT_TITLE, message: responceObj as! String)
                if self.salon_type == "0" {
                    self.getEmployListforAppointment()
                }
            }
        }
    }
    func DisplayDataToScrollview() {
        
    }
    func getTimeSlotofAppointment(employID:String,StrDate:String) {
        BasicStuff.showLoader(self.view)
        
//        emp_id [passed if salon is business not individual]
//        date [formate : Y-m-d]

        
        let sendDict = NSMutableDictionary()
        sendDict.setValue(Language.shared.Lang, forKey: "lang")
        sendDict.setValue(salon_id, forKey: "salon_id")
        sendDict.setValue(service_id, forKey: "service_id")
        sendDict.setValue(getAccestokenwithOutCredential, forKey: "access_token")
        sendDict.setValue(getUserIDwithOutCredential, forKey: "user_id")
        sendDict.setValue(employID, forKey: "emp_id")
        sendDict.setValue(StrDate, forKey: "date")
        print("sendDict:=\(sendDict)")
        
        let manager = ServiceCall(URL: API_SalonBook_TimeSlot)
        manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
        manager.setContentType(contentType: .multiPartForm)
        
        manager.POST(parameters: sendDict) { (success, responceObj) in
            
            SalonLog("responceObj:====>\(responceObj)")
            
            if success {
                let Obj = responceObj as! NSDictionary
                let flag = Obj.value(forKey: "flag") as! NSNumber
                
                if flag == 1 {
                    let Hours = Obj.value(forKey: "data") as? NSArray
                    if Hours?.count != 0 {
                        self.TimeSlot = Hours as! [String]
                        self.CollectionObj.reloadData()
                    }
                    print("Hours:=\(Hours!)")
                }
                else {
                    BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey: "msg") as! String)
                    self.TimeSlot.removeAll()
                    self.CollectionObj.reloadData()
                }
                
            }
            else {
                BasicStuff.showAlert(title: ALERT_TITLE, message: responceObj as! String)
                self.TimeSlot.removeAll()
                self.CollectionObj.reloadData()
            }
            
            BasicStuff.dismissLoader()
        }
    }
    
    func getEmployListforAppointment() {
//        Note : Call this api if salon type is business not individual

        BasicStuff.showLoader(self.view)
        
        let sendDict = NSMutableDictionary()
        sendDict.setValue(Language.shared.Lang, forKey: "lang")
        sendDict.setValue(salon_id, forKey: "salon_id")
        sendDict.setValue(service_id, forKey: "service_id")
        sendDict.setValue(getAccestokenwithOutCredential, forKey: "access_token")
        sendDict.setValue(getUserIDwithOutCredential, forKey: "user_id")
        print("sendDict:=\(sendDict)")
        let manager = ServiceCall(URL: API_SalonBook_EmployeeList)
        manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
        manager.setContentType(contentType: .multiPartForm)
        
        manager.POST(parameters: sendDict) { (success, responceObj) in
            
            SalonLog("responceObj:====>\(responceObj)")
            BasicStuff.dismissLoader()
            if success {
                let Obj = responceObj as! NSDictionary
                let flag = Obj.value(forKey: "flag") as! NSNumber
                
                if flag == 1 {
                   let employArray = Obj.value(forKey: "data") as? NSArray
                    var getDataArray =  [String]()
                    if employArray?.count != 0 && employArray != nil {
                        self.EmployeeList = employArray!
                        for k in 0..<self.EmployeeList.count {
                            let dataDic = self.EmployeeList[k] as! NSDictionary
                            getDataArray.append( dataDic.value(forKey: "employee_name") as! String)
                        }
                        self.StaffDD.dataSource = getDataArray
                        self.SelectedEmployeID = (self.EmployeeList[0] as! NSDictionary).value(forKey: "employee_id") as! String
                        self.btn_StaffDD.setTitle(getDataArray[0], for: .normal)
                        print("self.StaffDD.dataSource:=\(self.StaffDD.dataSource) & SelectedEmployeID:=\(self.SelectedEmployeID)")
                        let btn = UIButton()
                        btn.tag = 0
                        self.btn_DaysSelectionAction(btn)
//                        self.getTimeSlotofAppointment(employID: self.SelectedEmployeID, StrDate: self.SelectedDate)
                    }
                }
                else {
                    BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey: "msg") as! String)
                }
            }
            else {
                BasicStuff.showAlert(title: ALERT_TITLE, message: responceObj as! String)
            }
        }
    }
    
    func setLocaliztionStaticText() {

        self.title = LocalizedString(key: "lbl_BookingHeader")
        DateMessageView_lblTitle.text = LocalizedString(key:"Alert")
        DateMessageView_btnOk.setTitle(LocalizedString(key:"Comman_btn_Ok"), for: .normal)
        DateMessageView_btnCancel.setTitle(LocalizedString(key: "Comman_btn_Cancel"), for: .normal)
        lbl_StaticPromocode.text = LocalizedString(key: "lbl_Booking_Doyouhavepromocode")
        lbl_StaticNo.text = LocalizedString(key: "Comman_btn_No")
        lbl_StaticYes.text = LocalizedString(key: "Comman_btn_Yes")
        txt_Promocode.placeholder = LocalizedString(key: "txtPlace_Booking_Enterpromocodehere")
        txtview_Comment.placeholder = LocalizedString(key: "txtPlace_BookLastminOfferCell2_Comment")
        btn_FinishPayment.setTitle(LocalizedString(key: "lbl_BookLastminOfferCell3_FinishPayment"), for: .normal)
    }
    
//    MARK:- Date Calculation custom function
    func CheckDayisPresentOrNotinSelectedDate(passDate:String,DicData:[String]) -> Bool {
        
        let weekdaysName = getWeekDaysInEnglish()
        //"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
        print("DicData:===\(DicData)")
        var ConvertTotIndexOfDays = [Int]()
        for g in 0..<DicData.count {
            let day = weekdaysName.index(of: DicData[g])!
            ConvertTotIndexOfDays.append(day)
        }
        print("ConvertTotIndexOfDays:===\(ConvertTotIndexOfDays)")
        SetFirstDate = ConvertDateStringToDate(StrDate:passDate)
        print("SetFirstDate:=\(SetFirstDate)")
        let TodayWeekday = SetFirstDate.dayOfWeek()!
        print("TodayWeekday:=\(TodayWeekday)")
        let TodayDaysIndex = weekdaysName.index(of: TodayWeekday)!
        
        for m in 0..<ConvertTotIndexOfDays.count {
            if ConvertTotIndexOfDays[m] == TodayDaysIndex  {
                return true
            }
        }
        return false
    }
    
    func MakeDays(DicData:[String]) {
//        let DicData1 = ["Monday","Wednesday"]
        let weekdaysName = getWeekDaysInEnglish()
        //"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
        print("DicData:===\(DicData)")
        var ConvertTotIndexOfDays = [Int]()
        for g in 0..<DicData.count {
            let day = weekdaysName.index(of: DicData[g])!
            ConvertTotIndexOfDays.append(day)
        }
        print("ConvertTotIndexOfDays:===\(ConvertTotIndexOfDays)")
        var TotalDaysNumber = [Int]()
        SetFirstDate = ConvertDateStringToDate(StrDate:SelectedDate)
        print("SetFirstDate:=\(SetFirstDate)")
        let TodayWeekday = SetFirstDate.dayOfWeek()!
        print("TodayWeekday:=\(TodayWeekday)")
        let TodayDaysIndex = weekdaysName.index(of: TodayWeekday)!
        
        var count:Float = Float(7.0/Float.init(DicData.count))
        var getExect:Int = Int(count.rounded())
        
        for _ in 0...getExect {
            for l in 0..<ConvertTotIndexOfDays.count {
                if TotalDaysNumber.count != 7 {
                    print("ConvertTotIndexOfDays[\(l)]:===\(ConvertTotIndexOfDays[l])")
                    if ConvertTotIndexOfDays[l] >= TodayDaysIndex {
                        if TotalDaysNumber.count == 0 {
                            TotalDaysNumber.append(ConvertTotIndexOfDays[l])
                        }
                        else {
                            if TotalDaysNumber[0] == ConvertTotIndexOfDays[l] {
                                print("last")
                                break
                            }
                            else {
                                TotalDaysNumber.append(ConvertTotIndexOfDays[l])
                            }
                        }
                    }
                }
            }
        }
        
        print("TotalDaysNumber====>\(TotalDaysNumber)")
        
        count = Float(7.0/Float.init(DicData.count))
        getExect = Int(count.rounded())
        
        for _ in 0...getExect {
            for t in 0..<ConvertTotIndexOfDays.count {
                if TotalDaysNumber.count != 7 {
                    print("ConvertTotIndexOfDays[\(t)]:===\(ConvertTotIndexOfDays[t])")
                    TotalDaysNumber.append(ConvertTotIndexOfDays[t])
                }
            }
        }
        
        print("NowTotalDaysNumber====>\(TotalDaysNumber)")
        FirstIndexOfDay = TotalDaysNumber[0]
        
        TotalDays.removeAll()
        for f in 0..<TotalDaysNumber.count {
            let getDate = TotalDaysNumber[f]
            TotalDays.append(getDayname(getDayName:getDate))
        }
        print("OrignalDays:===>\(TotalDays)")
        

        let index = TotalDays[0].index(TotalDays[0].startIndex, offsetBy: 3)
        for days in 0..<TotalDays.count {
            lbl_Days[days].text = TotalDays[days].localizedUppercase.substring(to: index)
        }
        /*lbl_Day1.text = TotalDays[0].localizedUppercase.substring(to: index)
        lbl_Day2.text = TotalDays[1].localizedUppercase.substring(to: index)
        lbl_Day3.text = TotalDays[2].localizedUppercase.substring(to: index)
        lbl_Day4.text = TotalDays[3].localizedUppercase.substring(to: index)
        lbl_Day5.text = TotalDays[4].localizedUppercase.substring(to: index)
        lbl_Day6.text = TotalDays[5].localizedUppercase.substring(to: index)
        lbl_Day7.text = TotalDays[6].localizedUppercase.substring(to: index) */
        self.MakeDateDays(nextDate: SelectedDate)
    }
    
    func MakeDateDays(nextDate:String) {
        TotalDates.removeAll()
        let SetDateany = ConvertDateStringToDate(StrDate:SelectedDate)
        print("SetDateany:=\(SetDateany)")
        let getcheckToday = getTodayDate(myDate: SetFirstDate)
        print("getcheckToday:=\(getcheckToday)")
        var Day1:String = String()
        for z in 0..<TotalDays.count {
            if z == 0 {
                Day1 = getcheckToday
//                lbl_DateDay1.text = ConvertDateToSingleDay(strDate: Day1)
                lbl_DateDays[z].text = ConvertDateToSingleDay(strDate: Day1)
                print("Day\([z]):====\(Day1)")
                TotalDates.append(Day1)
            }
            else {
                Day1 = (getNextDate(direction: .Next, strDate: Day1, TotalDays[z]))
                print("Day\([z]):====\(Day1)")
                TotalDates.append(Day1)
                lbl_DateDays[z].text = ConvertDateToSingleDay(strDate: Day1)
            }
        }
        
        print("TotalDates:=\(TotalDates)")
    }
    func getTodayDate(myDate: Date) -> String {
        let dateFormate  = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd"
        let cal = Calendar.current
        var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: myDate)
        comps.weekday = FirstIndexOfDay + 1 // Monday
        let mondayInWeek = cal.date(from: comps)!
        return dateFormate.string(from: mondayInWeek)
    }
    func getDayname(getDayName:Int) -> String {
        
        var DayName = String()
        //"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
        switch getDayName {
        case 0:
            DayName = "Sunday"
            break
        case 1:
            DayName = "Monday"
            break
        case 2:
            DayName = "Tuesday"
            break
        case 3:
            DayName = "Wednesday"
            break
        case 4:
            DayName = "Thursday"
            break
        case 5:
            DayName = "Friday"
            break
        case 6:
            DayName = "Saturday"
            break
        default:
            break
        }
        return DayName
    }
    
    func ConvertDateStringToDate(StrDate:String) -> Date {
        let dateFormate  = DateFormatter()
        var StrDate1:String = StrDate
        StrDate1.append("T")
        StrDate1.append("05:30:00")
        //    let componentTime = Date()
        //    dateFormate.dateFormat = "hh:mm:ss"
        ////    dateFormate.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        //    //    dateFormate.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        //    let StrDate4 = dateFormate.string(from:componentTime)
        //    StrDate1.append("T")
        //    StrDate1.append(StrDate4)
        //    print(StrDate1)
        dateFormate.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        //    dateFormate.timeZone = NSTimeZone.local
        let date = dateFormate.date(from: StrDate1)
        //    print("date:===\(date!)")
        return date!
    }
    
    func ConvertDateToSingleDay(strDate:String) -> String {
        dateFormetter.dateFormat = "yyyy-MM-dd"
        dateFormetter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormetter.date(from: strDate)
        dateFormetter.dateFormat = "dd"
        let timeStamp = dateFormetter.string(from: date!)
        return timeStamp
    }
    func getWeekDaysInEnglish() -> [String] {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        calendar.locale = Locale.current
//        calendar.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        return calendar.weekdaySymbols
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarOptions: NSCalendar.Options {
            switch self {
            case .Next:
                return .matchNextTime
            case .Previous:
                return [.searchBackwards, .matchNextTime]
            }
        }
    }
    
    func getNextDate(direction: SearchDirection,strDate:String, _ dayName: String, considerToday consider: Bool = false) -> String {
        let weekdaysName = getWeekDaysInEnglish()
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let nextWeekDayIndex = weekdaysName.index(of: dayName)! + 1 // weekday is in form 1 ... 7 where as index is 0 ... 6
        
        let today = ConvertDateStringToDate(StrDate:strDate)
        //    print("today:===\(today)")
        
        let dateformate = DateFormatter()
        dateformate.dateFormat = "yyyy-MM-dd"
        
        //    dateformate.dateFormat = "hh:mm:ss"
        //    let stringDate = dateformate.string(from: today)
        //    let Array2 = stringDate.components(separatedBy: " ")
        //    print(Array2)
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        //    let comp = calendar.components([.hour,.minute,.second], from: today)
        //    print(comp.hour!)
        //    dateComponents([.year, .month, .day, .hour, .minute, .second], from: today)
        
        if consider && calendar.component(.weekday, from: today) == nextWeekDayIndex {
            return dateformate.string(from: today)
        }
        
        let nextDateComponent = NSDateComponents()
        nextDateComponent.weekday = nextWeekDayIndex
        nextDateComponent.hour = 05
        nextDateComponent.minute = 30
        nextDateComponent.second = 00
        
        let date = calendar.nextDate(after: today, matching: nextDateComponent as DateComponents, options: direction.calendarOptions)
        return dateformate.string(from: date!)
    }
    
//  MARK:- DatePicker Delegate
    func didSelectTime(time: String?) {
        print("time:=\(time)")
        if time != nil {
           let SelectedPassDate = BasicStuff.ConvertDateToServerDateFormate(StrDate: time!)
            if CheckDayisPresentOrNotinSelectedDate(passDate: SelectedPassDate, DicData: self.program) {
                SelectedDate = SelectedPassDate
                print("SelectedDate:=\(SelectedDate))")
                let getDate = BasicStuff.ConvertDateStringToDate(StrDate: SelectedDate)
                
                self.lbl_Date.text = BasicStuff.convertDateToMonthAndYear(strDate: getDate)
                self.getTimeSlotofAppointment(employID: self.SelectedEmployeID, StrDate: self.SelectedDate)
                self.MakeDays(DicData: self.program)
            }
            else {
                self.DateMessageView.isHidden = false
                var getNameProgram:String = ""
                for k in 0..<self.program.count {
                    getNameProgram.append(self.program[k])
                    if k != self.program.count - 1 {
                        getNameProgram.append(", ")
                    }
                }

                self.DateMessageView_lblMessage.text = "This salon only open in \(getNameProgram). so you have to select that day of week"
            }
//            self.MakeDateDays(nextDate: SelectedDate)
        }
    }
    
//  MARK:- Button Action
    @IBAction func btn_CalenderAction(_ sender: UIButton) {
//        datePicker.timePicker?.date = Date()
        datePicker.timePicker?.minimumDate = Date()
        datePicker.modalPresentationStyle = .overCurrentContext
        present(datePicker, animated: true, completion: nil)
    }

    @IBAction func btn_DaysSelectionAction(_ sender: UIButton) {
        BGDayViews.forEach({$0.backgroundColor = UIColor.white})
        BGDayViews[sender.tag].backgroundColor = UIColor.init(hexString: "#37ADD7")
        
        lbl_DateDays.forEach({$0.textColor = UIColor.init(hexString: "#666666")})
        lbl_DateDays[sender.tag].textColor = UIColor.white
        
        lbl_Days.forEach({$0.textColor = UIColor.init(hexString: "#666666")})
        lbl_Days[sender.tag].textColor = UIColor.white
        
        let DaysDate = TotalDates[sender.tag]
        print("DaysDate:===>\(DaysDate)")
        SelectedDate = DaysDate
        self.getTimeSlotofAppointment(employID: self.SelectedEmployeID, StrDate: DaysDate)
    }

    @IBAction func btn_YesBookAction(_ sender: UIButton) {
        print("Yes Click")
        if btn_YesBook.isSelected {
           btn_YesBook.isSelected = false
            Is_first = "0"
        }
        else {
            Is_first = "1"
           btn_YesBook.isSelected = true
            if btn_NoBook.isSelected {
                btn_NoBook.isSelected = false
            }
        }
    }
    @IBAction func btn_NoBookAction(_ sender: UIButton) {
        print("No Click")
        if btn_NoBook.isSelected {
            Is_first = "1"
            btn_NoBook.isSelected = false
        }
        else {
            Is_first = "0"
            btn_NoBook.isSelected = true
            if btn_YesBook.isSelected {
               btn_YesBook.isSelected = false
            }
        }
    }
    
    @IBAction func DateMessageView_btnCancelAndOk_Action(_ sender: UIButton) {
        self.DateMessageView.isHidden = true
        if sender.tag == 1 {
            // Ok Click
            self.btn_CalenderAction(sender)
        }
        else {
            // Cancel Click
        }
    }
    
   /* func btnTimeSlotAction(_ sender:UIButton) {
        let indexpath = sender.accessibilityElements?.first as! IndexPath
        print("Indexpath.section:=\(indexpath.section),Indexpath.row:=\(indexpath.row)")
    } */
    
    @IBAction func btn_StaffDD_Action(_ sender: UIButton) {
        
        StaffDD.show()
        StaffDD.selectionAction = { (index,item) in
            self.btn_StaffDD.setTitle(item, for: .normal)
            self.SelectedEmployeID = (self.EmployeeList[index] as! NSDictionary).value(forKey: "employee_id") as! String
            print("self.SelectedEmployeID:===\(self.SelectedEmployeID)")
        }
    }
    @IBAction func btn_FinishPaymentAction(_ sender: UIButton) {
//        lang [0 = Eng, 1 = romanian]
//        user_id
//        access_token
//        salon_id
//        offer_id [passed if book offer service]
//        service_id [passed if book service]
//        flag_view [0 = view service data, 1 = booking appointment ,2 = confirm booking]
//        
//        [Only if flag_view = 1 or 2]
//        selected_time [passed if you passed service_id]
//        selected_date [passed if you passed service_id]
//        emp_id [if salon_type = 0]
//        promocode [passed promocode and not passed offer_id]
//        is_first [0 = no, 1 = yes]
//        pay_type [passed if flag_view = 2] [0 =pay at venue, 1 = pay with stripe]
        
        if !(SelectedEmployeID.isEmpty) && !(SelectedTime.isEmpty) && !(SelectedDate.isEmpty) && !(Is_first.isEmpty) {
            
        }
        else {
            if SelectedEmployeID.isEmpty {
                BasicStuff.showAlert(title: ALERT_TITLE, message: "Please select employee")
                return
            }
            else if SelectedDate.isEmpty {
                BasicStuff.showAlert(title: ALERT_TITLE, message: "Please select date")
                return
            }
            else if SelectedTime.isEmpty {
                BasicStuff.showAlert(title: ALERT_TITLE, message: "Please select time")
                return
            }
            else {
                BasicStuff.showAlert(title: ALERT_TITLE, message: LocalizedString(key: "lbl_BookLastminOfferCell2_SuareTextBook"))
                return
            }
        }
        
        
        BasicStuff.showLoader(self.view)
        
        let sendDict = NSMutableDictionary()
        sendDict.setValue(Language.shared.Lang, forKey: "lang")
        sendDict.setValue(getUserIDwithOutCredential, forKey: "user_id")
        sendDict.setValue(getAccestokenwithOutCredential, forKey: "access_token")
        sendDict.setValue(salon_id, forKey: "salon_id")
        //        sendDict.setValue(Language.shared.Lang, forKey: "offer_id")
        sendDict.setValue(service_id, forKey: "service_id")
        sendDict.setValue(SelectedTime, forKey: "selected_time")
        sendDict.setValue(SelectedDate, forKey: "selected_date")
        sendDict.setValue(SelectedEmployeID, forKey: "emp_id")
        sendDict.setValue(txt_Promocode.text, forKey: "promocode")
        sendDict.setValue(Is_first, forKey: "is_first")
        sendDict.setValue(txtview_Comment.text, forKey: "message") // message [Only if flag_view = 1]
//        sendDict.setValue(service_id, forKey: "pay_type")
        sendDict.setValue("1", forKey: "flag_view") // 1 = booking appointment
        
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
                    let Data = Obj.value(forKey: "data") as! NSDictionary
                    let confirm = ConfirmBookingVC(nibName: "ConfirmBookingVC", bundle: nil)
                    confirm.getResult = Data
                    confirm.SalonType = self.salon_type
                    confirm.SelectedTime = self.SelectedTime
                    confirm.SelectedDate = self.SelectedDate
                    confirm.SelectedEmployeID = self.SelectedEmployeID
                    confirm.Is_first = self.Is_first
                    confirm.getBookingData = self.ResponceDataOfBookingDetail
                    self.navigationController?.pushViewController(confirm, animated: true)
                }
                else {
                    BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey: "msg") as! String)
                    self.TimeSlot.removeAll()
                    self.CollectionObj.reloadData()
                }
                
            }
            else {
                BasicStuff.showAlert(title: ALERT_TITLE, message: responceObj as! String)
            }
            
            BasicStuff.dismissLoader()
        }
        
//        let confirm = ConfirmBookingVC(nibName: "ConfirmBookingVC", bundle: nil)
////        confirm.getResult = Data
//        confirm.getBookingData = self.ResponceDataOfBookingDetail
//        self.navigationController?.pushViewController(confirm, animated: true)
       
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

extension BookingVC : UICollectionViewDelegateFlowLayout {
//    MARK:- Collectionview FlowLayOut Delegate
    
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let screenWidth = UIScreen.main.bounds.size.width
        print("screenWidth==\(screenWidth)")
        let getSingleWidth = screenWidth - 24 // (Spacing)
//        btnCellwidth = 95 + 10 (MiniSpacing)
        let Expectedwidth = 105 * 3
        print("Expectedwidth:=\(Expectedwidth)")
        print("getSingleWidth==\(getSingleWidth)")
        print("getSingleWidth/3 = \(getSingleWidth/3)")
        
//        let width = screenWidth/3
//        let height = CGFloat.init(40)
//        return CGSize(width: 105.0, height: height)//
//        print("yes..")
//        let paddingSpace = 5.0  * (itemsPerRow + 1)
        let availableWidth = getSingleWidth
        let widthPerItem = availableWidth / itemsPerRow
//
        return CGSize(width: widthPerItem, height: 34)
    }
    
//    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        //2
////        let paddingSpace = 0
////        let availableWidth = view.frame.width - paddingSpace
////        let widthPerItem = availableWidth / itemsPerRow
//        
//        return CGSize(width: view.frame.width / 5, height: 40)
//    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        print("min spacing is 0")
        return sectionInsets.left
    }
}
