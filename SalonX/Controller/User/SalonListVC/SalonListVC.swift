//
//  SalonListVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/21/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class SalonListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblSalonList: UITableView!
    
    var salonList:NSMutableArray = NSMutableArray()
    var getSubCategoryId:String!
    
    let refreshControl = UIRefreshControl()
    var offset:NSNumber = 0
    var flagView = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        setupBackButton()
        
        let buttonfilter = UIBarButtonItem(image: UIImage(named: "ic_filter_header"), style: .plain, target: self, action: #selector(self.btn_FilterAction(_:)))
        self.navigationItem.rightBarButtonItem = buttonfilter
        
        self.title = LocalizedString(key: "lbl_SalonListHeader")
        
        
        let nibName = UINib(nibName: "MyFavoriteCell", bundle: nil)
        tblSalonList.register(nibName, forCellReuseIdentifier: "MyFavoriteCell")
        
//        let BookNowNibName = UINib(nibName: "SalonBookNowCell1", bundle: nil)
//        tblSalonList.register(BookNowNibName, forCellReuseIdentifier: "SalonBookNowCell1")
        
        let SubBookNowNibName = UINib(nibName: "SalonBookNowSubCell", bundle: nil)
        tblSalonList.register(SubBookNowNibName, forCellReuseIdentifier: "SalonBookNowSubCell")
        
        refreshControl.addTarget(self, action: #selector(self.refreshTable), for: .valueChanged)
        self.tblSalonList.bottomRefreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        salonList.removeAllObjects()
        self.setLocalizedStaticText()
        if offset == 0 {
            offset = 0
            refreshControl.beginRefreshing()
            self.getSalonList()
        }
    }
    
    // MARK:- Custom Function
    func refreshTable(){
        refreshControl.beginRefreshing()
        self.getSalonList()
    }
    
    func dismissLogin() {
        
        self.dismiss(animated: true, completion: nil)
        BasicStuff.basic.IsFromScreen = ""
        let SalonId = BasicStuff.basic.storeBookingDetail.value(forKey: "salon_id") as! String
        let SalonServiceId = BasicStuff.basic.storeBookingDetail.value(forKey: "service_id") as! String
        let SalonType = BasicStuff.basic.storeBookingDetail.value(forKey: "salon_type") as! String
        
        let Booking = BookingVC(nibName: "BookingVC", bundle: nil)
        Booking.salon_id = SalonId
        Booking.service_id = SalonServiceId
        Booking.salon_type = SalonType
        self.navigationController?.pushViewController(Booking, animated: true)
        
    }

    func getSalonList() {
        print("offset.intValue:=\(offset.intValue)")
      if offset.intValue >= 0 {
        
        BasicStuff.showLoader(self.view)
        
        let getAccestokenwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("access_token")
        let getUserIDwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("user_id")
        
        let sendDict = NSMutableDictionary()
        sendDict.setValue(Language.shared.Lang, forKey: "lang")
        if flagView == "0" {
            sendDict.setValue(getSubCategoryId, forKey: "sub_category_id")
        }
        sendDict.setValue(getAccestokenwithOutCredential, forKey: "access_token")
        sendDict.setValue(getUserIDwithOutCredential, forKey: "user_id")
        sendDict.setValue(flagView, forKey: "flag_view")
//             flag_view   [0 = salon list, 1 = favorite salon list,2 = Available today]
        
        SalonLog("sendDict:====>\(sendDict)")
        
        let manager = ServiceCall(URL: API_SalonList)
        manager.setContentType(contentType: .multiPartForm)
        manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
        manager.POST(parameters: sendDict) { (success:Bool, responceObj:Any) in
            
            SalonLog("responceObj:====>\(responceObj)")
            self.refreshControl.endRefreshing()

            if success {
                let Obj = responceObj as! NSDictionary
                let flag = Obj.value(forKey: "flag") as! NSNumber
                if flag == 1 {
                   let SalonListData = Obj.value(forKey: "data") as! NSArray
                    self.offset = Obj.value(forKey: "next_offset") as! NSNumber
                    
                    if SalonListData.count != 0 {
                        
                        for i in 0..<SalonListData.count {
                            let getSalonMainList:NSMutableDictionary = (SalonListData[i] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            let getServiceList:NSMutableArray = (getSalonMainList["service"] as! NSArray).mutableCopy() as! NSMutableArray
                            print("getServiceList:=\(getServiceList)")
                            getSalonMainList.setValue("1", forKeyPath: "OurType")
                            getSalonMainList.removeObject(forKey: "service")
                            self.salonList.add(getSalonMainList)
                            if getServiceList.count != 0 {
                                for j in 0..<getServiceList.count {
                                    let getsubList = getServiceList[j] as! NSMutableDictionary
                                    getsubList.setValue("0", forKeyPath: "OurType")
                                    getsubList.setValue(getSalonMainList.value(forKey: "salon_type") as? String, forKey: "salon_type")
                                    getsubList.setValue(j, forKeyPath: "count")
                                    getsubList.setValue(getServiceList.count, forKeyPath: "TotalCount")
                                  getsubList.setValue(getSalonMainList["salon_id"] as? String, forKey: "salon_id")
                                    
                                    self.salonList.add(getsubList)
                                }
                            }
                        }
                        self.tblSalonList.reloadData()
                    }
                    else {
                         self.tblSalonList.reloadData()
                    }
                    print("Our SalonListArray:===> \n \(self.salonList)")
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
      else {
           refreshControl.endRefreshing()
      }

    }

    
    
    //  MARK:- Tabelview Delegate & DataSource
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if salonList.count != 0
        {
            numOfSections = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: -20, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = LocalizedString(key: "lbl_no_records_found")
            noDataLabel.font = UIFont(name: "Helvetica", size: 16)
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
        }
        return numOfSections
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return salonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DicData = salonList[indexPath.row] as! NSDictionary
        
        if DicData["OurType"] as! String == "1" {
            let cell = tblSalonList.dequeueReusableCell(withIdentifier: "MyFavoriteCell") as! MyFavoriteCell
            cell.lbl_Style.text = DicData["profession_name"] as? String
            if let salon_image = DicData["salon_image"] as? String {
                cell.Img_Salon.sd_setImage(with: URL.init(string: salon_image), placeholderImage: UIImage.init(named: "placeholder_listing_salon"))
            }
            if let rateTotal = DicData["rat_total"] as? String {
               cell.lbl_Review.text = "(\(rateTotal))"
            }else {
                cell.lbl_Review.text = "(0)"
            }
            
            cell.lbl_Address.text = DicData["address"] as? String
            if let rate = DicData["rat_avg"] as? NSString {
                let getFloat:Float = rate.floatValue/10
                cell.lbl_Ratingview.setScore(getFloat, withAnimation: false)
            }
            cell.btn_Favorite.isHidden = true
            cell.lbl_BottmBorder.isHidden = false
            cell.lbl_Name.text = DicData["salon_name"] as? String
            return cell
        }
        else {
            let cell = tblSalonList.dequeueReusableCell(withIdentifier: "SalonBookNowSubCell") as! SalonBookNowSubCell
            let count =  DicData["count"] as! Int
            let TotalCount = DicData  ["TotalCount"] as! Int
            
            if count == TotalCount - 1 {
                cell.Constanlbl_StyleNameBottom.constant = 20
            }
            else {
                cell.Constanlbl_StyleNameBottom.constant = 5
            }
            cell.lbl_Time.text = DicData["duration"] as? String
            cell.lbl_Price.text = DicData["price"] as? String
            cell.btn_BookNow.accessibilityElements = [indexPath]
            cell.btn_BookNow.addTarget(self, action: #selector(self.btn_BookNowAction), for: .touchUpInside)
            cell.lbl_StyleName.text = DicData["service_name"] as? String
            
            return cell
        }
        
       /* cell.btn_Favorite.tag = indexPath.row
        cell.btn_Favorite.addTarget(self, action: #selector(btn_FavoriteAction(_:)), for: .touchUpInside) */
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DicData = salonList[indexPath.row] as! NSDictionary        
        let SalonDetail = SalonDetailVC(nibName: "SalonDetailVC", bundle: nil)
        SalonDetail.salon_id = DicData["salon_id"] as? String
        SalonDetail.salon_type = DicData["salon_type"] as? String
        self.navigationController?.pushViewController(SalonDetail, animated: true)
    }
    
    //    MARK:- Custom Function
    func setLocalizedStaticText() {
        self.title = LocalizedString(key: "lbl_SalonListHeader")
        
    }
    
    //    MARK:- Button Action
 /* func btn_FavoriteAction(_ sender:UIButton) {
        print("Favorite Click @ index:=\(sender.tag)")
        
    } */
    
    func btn_BookNowAction(_ sender:UIButton) {
        let indexpath = sender.accessibilityElements?.first as! IndexPath
        let DicData = salonList[indexpath.row] as! NSDictionary
        print("DicData:=\(DicData)")
        let getuserid = BasicStuff.getClienDetailWithoutCerdential(Key_IsLogin)
        if  getuserid == "0" {
            let dicData = ["salon_id":DicData.value(forKey: "salon_id") as! String,"service_id":DicData.value(forKey: "service_id") as! String,"salon_type":DicData.value(forKey: "salon_type") as! String]
            BasicStuff.basic.storeBookingDetail = dicData as NSDictionary!
                        
            print("BasicStuff Dictionary:====> \(BasicStuff.basic.storeBookingDetail!)")
            BasicStuff.basic.IsFromScreen = self.nibName!
            print("BasicStuff.basic.IsFromScreen:===> \(BasicStuff.basic.IsFromScreen)")
            let vc = LoginViewController()
            vc.salonListVC = self
            let navCV = UINavigationController(rootViewController: vc)
            self.present(navCV, animated: true, completion: nil)
            
        }else {
            let Booking = BookingVC(nibName: "BookingVC", bundle: nil)
            Booking.salon_id = DicData.value(forKey: "salon_id") as! String
            Booking.service_id = DicData.value(forKey: "service_id") as! String
            Booking.salon_type = DicData.value(forKey: "salon_type") as! String
            self.navigationController?.pushViewController(Booking, animated: true)
        }
    }
    func btn_FilterAction(_ sender:UIButton) {
        let filter = FilterVC(nibName: "FilterVC", bundle: nil)
        self.navigationController?.pushViewController(filter, animated: true)
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
