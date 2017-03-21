//
//  LastMintOfferVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/20/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class LastMintOfferVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tblLastMintOffer: UITableView!
    var IsBackArrow:String!
    
    var OfferArray = NSMutableArray()
    var OfferFalg:NSNumber = 0
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.isHidden = false
        
        if IsBackArrow == "Yes" {
//            let Backbutton = UIBarButtonItem(image: UIImage(named: "ic_back_header_white"), style: .plain, target: self, action: #selector(self.btn_backAction)) // action:#selector(Class.MethodName) for swift 3
//            self.navigationItem.leftBarButtonItem  = Backbutton
            setupBackButton()
        }
        else {
            let buttonMenu = UIBarButtonItem(image: UIImage(named: "ic_menubar_header"), style: .plain, target: self, action: #selector(self.btn_LeftMenuAction)) // action:#selector(Class.MethodName) for swift 3
            self.navigationItem.leftBarButtonItem  = buttonMenu
        }
        
        
        
        let buttonfilter = UIBarButtonItem(image: UIImage(named: "ic_filter_header"), style: .plain, target: self, action: #selector(self.btn_FilterAction(_:)))
        self.navigationItem.rightBarButtonItem = buttonfilter
        
//        self.title = "Last min Offer"
//        self.navigationController?.navigationBar.topItem?.title = "Last min Offer"
        
        let lastMintNib = UINib(nibName: "LastMintOfferCell", bundle: nil)
        tblLastMintOffer.register(lastMintNib, forCellReuseIdentifier: "LastMintOfferCell")
        
        refreshControl.addTarget(self, action: #selector(self.refreshTable), for: .valueChanged)
        self.tblLastMintOffer.bottomRefreshControl = refreshControl
        
        self.refreshTable()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = LocalizedString(key: "lbl_LastMintOfferHeader")
        
    }
    func refreshTable(){
        refreshControl.beginRefreshing()
        self.getSalonLastMintOfferList()
    }
//    MARK:- Custom Function
    func getSalonLastMintOfferList() {
        //        flag_view  [0 = service and info details, 1 = offer details, 2= reviews details]
        
        if OfferFalg.intValue >= 0 {
            
            BasicStuff.showLoader(self.view)
            
            let getAccestokenwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("access_token")
            let getUserIDwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("user_id")
            
            let sendDict = NSMutableDictionary()
            sendDict.setValue("1", forKey: "flag_view")
            sendDict.setValue(Language.shared.Lang, forKey: "lang")
            sendDict.setValue(OfferFalg.stringValue, forKey: "offset")
            sendDict.setValue(getAccestokenwithOutCredential, forKey: "access_token")
            sendDict.setValue(getUserIDwithOutCredential, forKey: "user_id")
            
            let manager = ServiceCall(URL: API_SalonDetail)
            manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
            manager.setContentType(contentType: .multiPartForm)
            
            
            manager.POST(parameters: sendDict) { (success, responceObj) in
                
                SalonLog("responceObj:====>\(responceObj)")
                self.refreshControl.endRefreshing()
                
                if success {
                    let Obj = responceObj as! NSDictionary
                    let flag = Obj.value(forKey: "flag") as! NSNumber
                    self.OfferFalg = Obj.value(forKey: "next_offset") as! NSNumber
                    if flag == 1 {
                        let arrayOffer = (Obj.value(forKey: "data") as! NSDictionary).value(forKey: "offer_list") as! NSArray
                        for r in 0..<arrayOffer.count {
                            self.OfferArray.add(arrayOffer[r] as! NSDictionary)
                        }
                        print("OfferArray:=\(self.OfferArray)")
                        self.tblLastMintOffer.reloadData()
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
            
        }else {
            refreshControl.endRefreshing()
        }
    }
    

    //    MARK:- Tableview Delegate & DataSource
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if OfferArray.count != 0
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
        return OfferArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblLastMintOffer.dequeueReusableCell(withIdentifier: "LastMintOfferCell") as! LastMintOfferCell
        let DicData = self.OfferArray[indexPath.row] as! NSDictionary
        
        if let imgLast = DicData.value(forKey: "offer_image") as? String {
            cell.Img_LastMint.sd_setImage(with:URL.init(string: imgLast) , placeholderImage: UIImage.init(named: "placeholder_listing_salon"))
        }
        cell.lbl_Title.text =  DicData.value(forKey: "service") as? String
        cell.lbl_Offer.text = DicData.value(forKey: "discount") as? String
        cell.lbl_NewPrice.text = DicData.value(forKey: "offer_price") as? String
        cell.lbl_OldPrice.text = DicData.value(forKey: "regular_price") as? String
        cell.lbl_OldPrice.attributedText = BasicStuff.setStrikethroughStyleAttributeedText(cell.lbl_OldPrice.text!)
        cell.lbl_Time.text = DicData.value(forKey: "offer_date") as? String
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Detail = LastMintOfferDetailVC(nibName: "LastMintOfferDetailVC", bundle: nil)
        self.navigationController?.pushViewController(Detail, animated: true)
        
    }
    
//    MARK:- Button Action
    func btn_FilterAction(_ sender:UIButton) {
        let filter = FilterVC(nibName: "FilterVC", bundle: nil)
        self.navigationController?.pushViewController(filter, animated: true)
    }
    //   MARK:- Back Action
    func btn_backAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
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
