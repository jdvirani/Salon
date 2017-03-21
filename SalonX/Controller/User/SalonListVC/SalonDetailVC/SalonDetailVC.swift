//
//  SalonDetailVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/22/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class SalonDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource,KIImagePagerDelegate,KIImagePagerDataSource,UIScrollViewDelegate {

    @IBOutlet weak var MainScrollview: UIScrollView!
    @IBOutlet weak var imagePager: KIImagePager!
    @IBOutlet weak var TabView: UIView!
    @IBOutlet weak var btn_Service: UIButton!
    @IBOutlet weak var btn_Offers: UIButton!
    @IBOutlet weak var btn_Info: UIButton!
    @IBOutlet weak var btn_Reviews: UIButton!
    
    @IBOutlet weak var lbl_StylishName: UILabel!
    
    @IBOutlet weak var lbl_Style: UILabel!
    @IBOutlet weak var lbl_StarCount: UILabel!
    @IBOutlet weak var lbl_StarView: TQStarRatingView!
    
    @IBOutlet weak var btn_Favorite: UIButton!
    @IBOutlet weak var constantTblSalonDetailHeight: NSLayoutConstraint! //340
    
    @IBOutlet weak var tblSalonDetail: UITableView!
    
    var InfonumberOfLine:Int = 0
    var salon_id:String!
    var salon_type:String!
    
    var ServiceNInfoData:NSDictionary!
    var ServiceArray = NSArray()
    
    var InfoData:NSDictionary!
    var InfoArrayData = NSMutableArray()
    
    var ReviewArray = NSMutableArray()
    var ReviewFalg:NSNumber = 0
    
    var OfferArray = NSMutableArray()
    var OfferFalg:NSNumber = 0
    
    let refreshControl = UIRefreshControl()
    
    var Salon_Image:[String] = [String]()
    
    let getAccestokenwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("access_token")
    let getUserIDwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("user_id")
    
//    MARK:- ViewController cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePager.imageCounterDisabled = true
        
        // Do any additional setup after loading the view.
       self.btn_SelectionAction(btn_Service)
        
        self.navigationController?.navigationBar.isHidden = false
        setupBackButton()
        
        let HeaderView = UIButton.init(frame: CGRect(x: 0, y: -20, width: 42, height: 22))
        HeaderView.setBackgroundImage(UIImage(named: "logo_header"), for: .normal)
        self.navigationItem.titleView = HeaderView
        
        let buttonShare = UIBarButtonItem(image: UIImage(named: "ic_share_header"), style: .plain, target: self, action: #selector(self.btn_ShareAction))
        self.navigationItem.rightBarButtonItem  = buttonShare
        
        TabView.layer.borderColor = UIColor.init(hexString: "#049FCF").cgColor
        lbl_Style.text = "B"
        lbl_StylishName.text = "T"
        lbl_StarCount.text = "(75)"
        
        let SlonDetailServiceNibName = UINib(nibName: "SalonDetailServiceCells", bundle: nil)
        tblSalonDetail.register(SlonDetailServiceNibName, forCellReuseIdentifier: "SalonDetailServiceCells")
        
        let lastMintNib = UINib(nibName: "LastMintOfferCell", bundle: nil)
        tblSalonDetail.register(lastMintNib, forCellReuseIdentifier: "LastMintOfferCell")
        
        let SlonDetailReviewNibName = UINib(nibName: "SalonDetailReviewCell", bundle: nil)
        tblSalonDetail.register(SlonDetailReviewNibName, forCellReuseIdentifier: "SalonDetailReviewCell")
        
        let SalonDetailInfoDescriptionNibName = UINib(nibName: "SalonDetailInfoDescriptionCell", bundle: nil)
        tblSalonDetail.register(SalonDetailInfoDescriptionNibName, forCellReuseIdentifier: "SalonDetailInfoDescriptionCell")
        
        let SalonDetailInfoHeaderNibName = UINib(nibName: "SalonDetailInfoHeaderCell", bundle: nil)
        tblSalonDetail.register(SalonDetailInfoHeaderNibName, forCellReuseIdentifier: "SalonDetailInfoHeaderCell")
        
        let SalonDetailInfoProgramNibName = UINib(nibName: "SalonDetailInfoProgramCell", bundle: nil)
        tblSalonDetail.register(SalonDetailInfoProgramNibName, forCellReuseIdentifier: "SalonDetailInfoProgramCell")
        
        let SalonDetailInfoLocationNibName = UINib(nibName: "SalonDetailInfoLocationCell", bundle: nil)
        tblSalonDetail.register(SalonDetailInfoLocationNibName, forCellReuseIdentifier: "SalonDetailInfoLocationCell")
        
        let SalonDetailInfoUtilityNibName = UINib(nibName: "SalonDetailInfoUtilityCell", bundle: nil)
        tblSalonDetail.register(SalonDetailInfoUtilityNibName, forCellReuseIdentifier: "SalonDetailInfoUtilityCell")
        
        let SalonDetailInfoSocialNibName = UINib(nibName: "SalonDetailInfoSocialCell", bundle: nil)
        tblSalonDetail.register(SalonDetailInfoSocialNibName, forCellReuseIdentifier: "SalonDetailInfoSocialCell")
        
        let SalonDetailInfoTeamNibName = UINib(nibName: "SalonDetailInfoTeamCell", bundle: nil)
        tblSalonDetail.register(SalonDetailInfoTeamNibName, forCellReuseIdentifier: "SalonDetailInfoTeamCell")
        
//        self.refreshControl.addTarget(self, action: #selector(self.refreshTable), for: .valueChanged)
//        self.MainScrollview.bottomRefreshControl = self.refreshControl
        
//        refreshControl.addTarget(self, action: #selector(self.refreshTable), for: .valueChanged)
//        self.tblSalonDetail.bottomRefreshControl = refreshControl
        
//        tblSalonDetail.reloadData()
        
//        constantTblSalonDetailHeight.constant = self.preferredContentSize.height + 20
//        print("constantTblSalonDetailHeight:=\(constantTblSalonDetailHeight.constant)")
        if !(salon_id.isEmpty) {
             self.getSalonDetail(salonID: salon_id, flag_view: "0")
        }
        else {
            tblSalonDetail.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLocalizedStaticText()        
        tblSalonDetail.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions(), context: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tblSalonDetail.removeObserver(self, forKeyPath: "contentSize")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        imagePager.pageControl.currentPageIndicatorTintColor = UIColor.init(red: 4/255, green: 159/255, blue: 207/255, alpha: 1)// HexStringColor:= "049FCF"
        imagePager.pageControl.pageIndicatorTintColor = UIColor.white
        imagePager.slideshowTimeInterval = UInt(3.5)
        imagePager.slideshowShouldCallScrollToDelegate = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        imagePager.slideshowTimeInterval = UInt(0.0)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is UITableView {
            constantTblSalonDetailHeight.constant = self.tblSalonDetail.contentSize.height
            print("constantTblSalonDetailHeight:=\(constantTblSalonDetailHeight.constant)")
        }
    }
    
    func refreshTable(){
        if btn_Offers.isSelected == true {
            refreshControl.beginRefreshing()
            self.getSalonForOfferListTab(salonID: salon_id)
        }
        else if btn_Reviews.isSelected == true {
            refreshControl.beginRefreshing()
            self.getSalonForReviewDetailTab(salonID: salon_id)
        }
        else {
           refreshControl.endRefreshing()
        }
    }

    
//    MARK:- KIImagePager DataSource
    func array(withImages pager: KIImagePager!) -> [Any]! {
         return Salon_Image
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
    
    
    
    //    MARK:- Tableview Delegate & DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if btn_Service.isSelected == true {
            return 35
        }
        else if btn_Reviews.isSelected == true {
            return 50
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if btn_Service.isSelected == true {
            return 35
        }
        else if btn_Reviews.isSelected == true {
            return 50
        }
        else {
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if btn_Service.isSelected == true {
            return self.ServiceArray.count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let MainView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 35))
        MainView.backgroundColor = UIColor.white
        
        let txtLabel = UILabel.init(frame: CGRect(x: 15, y: 10, width: self.view.bounds.size.width - 30, height: 20))
        txtLabel.font = UIFont(name: "Helvetica-Bold", size: 13.0)
        MainView.addSubview(txtLabel)
        
        let Img_Border:UIImageView!
        if btn_Reviews.isSelected == true {
            Img_Border = UIImageView.init(frame: CGRect(x: 5, y: 39, width: self.view.bounds.size.width - 10, height: 1))
        }
        else {
            Img_Border = UIImageView.init(frame: CGRect(x: 5, y: 34, width: self.view.bounds.size.width - 10, height: 1))
        }
        
        Img_Border.image = UIImage(named: "seprator_dotted")
        MainView.addSubview(Img_Border)
        if btn_Service.isSelected == true {
            txtLabel.text = (self.ServiceArray[section] as! NSDictionary).value(forKey: "category_name") as? String
            txtLabel.textColor = UIColor.init(hexString: "#049FCF")
            return MainView
        }
        else if btn_Reviews.isSelected == true {
            txtLabel.font = UIFont(name: "Helvetica", size: 14.0)
            txtLabel.text = "\(LocalizedString(key: "lbl_SalonDetail_Reviews_TotalReview"))  \(self.lbl_StarCount.text!)"
            txtLabel.textColor = UIColor.init(hexString: "#2B2D2D")
            return MainView
        }
        else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if btn_Service.isSelected == true {
            return ((self.ServiceArray[section] as! NSDictionary).value(forKey: "service") as! NSArray).count
        }
        else if btn_Offers.isSelected == true {
            return OfferArray.count
        }
        else if btn_Info.isSelected == true {
            return InfoArrayData.count
        }
        else {
            return self.ReviewArray.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if btn_Service.isSelected == true {
            
            let cell = tblSalonDetail.dequeueReusableCell(withIdentifier: "SalonDetailServiceCells") as! SalonDetailCells
            let DicData = ((self.ServiceArray[indexPath.section] as! NSDictionary).value(forKey: "service") as! NSArray)[indexPath.row] as! NSDictionary
            print("DicData:=\(DicData)")
            
            cell.lbl_StylishName.text = DicData["service_name"] as? String
            cell.lbl_Time.text = "(\(DicData["duration"] as! String))"
            cell.lbl_Price.text = DicData["price"] as? String
            cell.lbl_Description.text = DicData["description"] as? String
            cell.btn_BookNow.setTitle(LocalizedString(key: "btn_BookLastminOfferCell_BookNow"), for: .normal)
            cell.btn_BookNow.accessibilityElements = [indexPath]
            cell.btn_BookNow.addTarget(self, action: #selector(self.btn_BookNowAction), for: .touchUpInside)
            return cell
        }
        else if btn_Offers.isSelected == true {
            
            let cell = tblSalonDetail.dequeueReusableCell(withIdentifier: "LastMintOfferCell") as! LastMintOfferCell
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
        else if btn_Info.isSelected == true {
            
            
            let DataDic = self.InfoArrayData[indexPath.row] as! NSDictionary
            
            if (DataDic.value(forKey: "Title") as? String) != nil {
                let Key = DataDic.value(forKey: "Key") as! String
                
                if Key == "program" {
                    let cell = tblSalonDetail.dequeueReusableCell(withIdentifier: "SalonDetailInfoHeaderCell") as! SalonDetailCells
                    cell.lbl_InfoHeader.text = LocalizedString(key: "lbl_SalonDetail_Reviews_Program")
                    //cell.lbl_InfoHeaderBorder.addDashedLine()
                    return cell
                }
                else if Key == "location" {
                    let cell = tblSalonDetail.dequeueReusableCell(withIdentifier: "SalonDetailInfoHeaderCell") as! SalonDetailCells
                    cell.lbl_InfoHeader.text = LocalizedString(key: "lbl_SalonDetail_Reviews_Location")
                    //cell.lbl_InfoHeaderBorder.addDashedLine()
                    return cell
                }
                else if Key == "utility" {
                    let cell = tblSalonDetail.dequeueReusableCell(withIdentifier: "SalonDetailInfoHeaderCell") as! SalonDetailCells
                    cell.lbl_InfoHeader.text = LocalizedString(key: "lbl_SalonDetail_Reviews_Utility")
                    //cell.lbl_InfoHeaderBorder.addDashedLine()
                    return cell
                }
                else if Key == "social" {
                    let cell = tblSalonDetail.dequeueReusableCell(withIdentifier: "SalonDetailInfoHeaderCell") as! SalonDetailCells
                    cell.lbl_InfoHeader.text = LocalizedString(key: "lbl_SalonDetail_Reviews_SocialMedia")
                    //cell.lbl_InfoHeaderBorder.addDashedLine()
                    return cell
                }
                else  {
                    //                    Key = Team
                    let cell = tblSalonDetail.dequeueReusableCell(withIdentifier: "SalonDetailInfoHeaderCell") as! SalonDetailCells
                    cell.lbl_InfoHeader.text = LocalizedString(key: "lbl_SalonDetail_Reviews_OurTeam")
                    //cell.lbl_InfoHeaderBorder.addDashedLine()
                    return cell
                    
                }
                
                
            }
            else {
                
                let Key = DataDic.value(forKey: "Key") as! String
                
                if Key == "description" {
                    let cell = tblSalonDetail.dequeueReusableCell(withIdentifier: "SalonDetailInfoDescriptionCell") as! SalonDetailCells
                    if let description = DataDic.value(forKey: "description") as? String {
                        cell.lbl_InfoDescription.text = description.htmlDecoded()
                    }else {
                        cell.lbl_InfoDescription.text = ""
                        cell.btn_InfoViewMore.isHidden = true
                    }
                    
                    
                    print("InfonumberOfLine:=\(cell.lbl_InfoDescription.numberOfLines)")
                    if InfonumberOfLine == 2 {
                        cell.lbl_InfoDescription.numberOfLines = 0
                        cell.btn_InfoViewMore.setTitle(LocalizedString(key: "lbl_SalonDetail_Reviews_MinsViewMore"), for: .normal)
                    }
                    else {
                        cell.lbl_InfoDescription.numberOfLines = 2
                        cell.btn_InfoViewMore.setTitle(LocalizedString(key: "lbl_SalonDetail_Reviews_PlusViewMore"), for: .normal)
                    }
                    
                    cell.btn_InfoViewMore.accessibilityElements = [indexPath]
                    cell.btn_InfoViewMore.addTarget(self, action: #selector(self.btn_infoViewMoreAction(_:)), for: .touchUpInside)
                    return cell
                }
                else if Key == "program" {
                    let cell = tblSalonDetail.dequeueReusableCell(withIdentifier: "SalonDetailInfoProgramCell") as! SalonDetailCells
                    let programArray = DataDic.value(forKey: "salon_program") as! NSArray
                    var Days = String()
                    var Times = String()
                    for p in 0..<programArray.count {
                        Days += (programArray[p] as! NSDictionary).value(forKey: "day_name") as! String
                        Times += (programArray[p] as! NSDictionary).value(forKey: "start_time") as! String
                        Times += "-"
                        Times += (programArray[p] as! NSDictionary).value(forKey: "end_time") as! String
//                        cell.lbl_ProgramDays.text 
                        if p == programArray.count - 1 {
                            
                        }else {
                            Days += "\n"
                            Times += "\n"
                        }
                    }
                    cell.lbl_ProgramDays.text = Days
                    cell.lbl_ProgramDays.setLineHeight(lineHeight: 1)
                    cell.lbl_ProgramTimes.text = Times
                    cell.lbl_ProgramTimes.setLineHeight(lineHeight: 1)
                    return cell
                }
                else if Key == "location" {
                    let cell = tblSalonDetail.dequeueReusableCell(withIdentifier: "SalonDetailInfoLocationCell") as! SalonDetailCells
                    if let lattitude = DataDic.value(forKey: "latitude") as? String,let longitude = DataDic.value(forKey: "longtitude") as? String {
                        
                         cell.setMapviewCustomLocationandPininSalonDetailInfo(strLat: lattitude, strLon: longitude)
                    }
                    else {
                        cell.setMapviewCustomLocationandPininSalonDetailInfo(strLat: "0.00", strLon: "0.00")
                    }
                    cell.lbl_InfoLocationAddress.text = DataDic.value(forKey: "address") as? String
                    return cell
                }
                else if Key == "utility" {
                    let cell = tblSalonDetail.dequeueReusableCell(withIdentifier: "SalonDetailInfoUtilityCell") as! SalonDetailCells
                    let utilityArray = DataDic.value(forKey: "utility") as! NSArray
                    var utilityValue = String()
                    for u in 0..<utilityArray.count {
                        utilityValue += ((utilityArray[u] as! NSDictionary).value(forKey: "title") as! String)
                        if u == utilityArray.count - 1 {
                            
                        }else {
                            utilityValue += "\n"
                        }
                    }
                    cell.lbl_InfoUtilityName.text = utilityValue
                    cell.lbl_InfoUtilityName.setLineHeight(lineHeight: 1)
                    return cell
                }
                else if Key == "social" {
                    let cell = tblSalonDetail.dequeueReusableCell(withIdentifier: "SalonDetailInfoSocialCell") as! SalonDetailCells
                    cell.setBorderToSocialButton()
                    cell.btn_InfoSocialFB.accessibilityElements = [indexPath]
                    cell.btn_InfoSocialInsta.accessibilityElements = [indexPath]
                    cell.btn_InfoSocialGPluse.accessibilityElements = [indexPath]
                    cell.btn_InfoSocialTwitter.accessibilityElements = [indexPath]
                    cell.btn_InfoSocialPinteres.accessibilityElements = [indexPath]
                    cell.btn_InfoSocialYoutube.accessibilityElements = [indexPath]
                    
                    cell.btn_InfoSocialFB.addTarget(self, action: #selector(self.btn_InfoSocialFBAction(_:)), for: .touchUpInside)
                    cell.btn_InfoSocialInsta.addTarget(self, action: #selector(self.btn_InfoSocialInstaAction(_:)), for: .touchUpInside)
                    cell.btn_InfoSocialGPluse.addTarget(self, action: #selector(self.btn_InfoSocialGpluseAction(_:)), for: .touchUpInside)
                    cell.btn_InfoSocialTwitter.addTarget(self, action: #selector(self.btn_InfoSocialTwitterAction(_:)), for: .touchUpInside)
                    cell.btn_InfoSocialPinteres.addTarget(self, action: #selector(self.btn_InfoSocialPintrestAction(_:)), for: .touchUpInside)
                    cell.btn_InfoSocialYoutube.addTarget(self, action: #selector(self.btn_InfoSocialYouTubeAction(_:)), for: .touchUpInside)
                    
                    cell.btn_InfoSocialTwitter.isHidden = true
                    return cell
                }
                else  {
//                    Key = Team
                    let cell = tblSalonDetail.dequeueReusableCell(withIdentifier: "SalonDetailInfoTeamCell") as! SalonDetailCells
                    if let employee = DataDic.value(forKey: "salon_employee") as? NSArray {
                        cell.setCollectionviewData(Employee: employee)
                    }
                    return cell
                }
            }
        }
        else {
            
            let cell = tblSalonDetail.dequeueReusableCell(withIdentifier: "SalonDetailReviewCell") as! SalonDetailCells
            let DataDic = self.ReviewArray[indexPath.row] as! NSDictionary
            
            if let imgPic = DataDic.value(forKey: "profile_img") as? String {
                cell.Img_PersonReview.sd_setImage(with: URL.init(string: imgPic), placeholderImage: UIImage.init(named: "user_placeholder_salon_member"))
            }
            if let styleName = DataDic.value(forKey: "service_name") as? String, let Days = DataDic.value(forKey: "time") as? String {
                cell.lbl_StyleReivew.text = "(\(styleName))"
                cell.lbl_DaysReivew.text = "(\(Days))"
            }
            else {
                cell.lbl_StyleReivew.text = ""
                cell.lbl_DaysReivew.text = ""
            }
            
            if let starCount = DataDic.value(forKey: "rating") as? NSString {
                cell.lbl_StarViewReivew.setScore(Float(starCount.floatValue/10), withAnimation: false)
            }
            else {
                cell.lbl_StarViewReivew.setScore(0, withAnimation: false)
            }
            
            
            
            cell.lbl_DescriptionReivew.text = DataDic.value(forKey: "review") as? String
            
//            cell.lbl_DescriptionReivew.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua,sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            //cell.lbl_BorderReivew.addDashedLine()
            cell.lbl_NameReivew.text = DataDic.value(forKey: "user_name") as? String
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if btn_Offers.isSelected == true {
            let Detail = LastMintOfferDetailVC(nibName: "LastMintOfferDetailVC", bundle: nil)
            self.navigationController?.pushViewController(Detail, animated: true)
        }
    }
    
    
    
    //    MARK:- Custom Function
    func socialShare(sharingText: String?, sharingImage: UIImage?, sharingURL: NSURL?) {
        var sharingItems = [AnyObject]()
        
        if let text = sharingText {
            sharingItems.append(text as AnyObject)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.copyToPasteboard,UIActivityType.airDrop,UIActivityType.addToReadingList,UIActivityType.assignToContact,UIActivityType.postToTencentWeibo,UIActivityType.postToVimeo,UIActivityType.print,UIActivityType.saveToCameraRoll,UIActivityType.postToWeibo]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func setLocalizedStaticText() {
        btn_Service.setTitle(LocalizedString(key: "btn_SalonDetail_Services"), for: .normal)
        btn_Offers.setTitle(LocalizedString(key: "btn_SalonDetail_Offers"), for: .normal)
        btn_Info.setTitle(LocalizedString(key: "btn_SalonDetail_Info"), for: .normal)
        btn_Reviews.setTitle(LocalizedString(key: "btn_SalonDetail_Reviews"), for: .normal)
    }
    
    func getSalonDetail(salonID:String,flag_view:String) {
//        flag_view  [0 = service and info details, 1 = offer details, 2= reviews details]
        BasicStuff.showLoader(self.view)
        
        let sendDict = NSMutableDictionary()
        sendDict.setValue(flag_view, forKey: "flag_view")
        sendDict.setValue(Language.shared.Lang, forKey: "lang")
        sendDict.setValue(salonID, forKey: "salon_id")
        sendDict.setValue(getAccestokenwithOutCredential, forKey: "access_token")
        sendDict.setValue("0", forKey: "offset")
        sendDict.setValue(getUserIDwithOutCredential, forKey: "user_id")
        print("sendDict:=\(sendDict)")
        let manager = ServiceCall(URL: API_SalonDetail)
        manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
        manager.setContentType(contentType: .multiPartForm)
        
        manager.POST(parameters: sendDict) { (success, responceObj) in
            
            SalonLog("responceObj:====>\(responceObj)")
            
            if success {
                let Obj = responceObj as! NSDictionary
                let flag = Obj.value(forKey: "flag") as! NSNumber
                
                if flag == 1 {
//                        0 = service and info details
                        self.ServiceNInfoData = Obj.value(forKey: "data") as! NSDictionary
                        if let isFavorite = self.ServiceNInfoData["is_favorite"] as? NSNumber {
                            if isFavorite == 1 {
                                if self.btn_Favorite.isSelected != true {
                                    self.btn_Favorite.isSelected = true
                                }
                            }
                            else {
                                if self.btn_Favorite.isSelected != false {
                                    self.btn_Favorite.isSelected = false
                                }
                            }
                        }
                        else {
                            self.btn_Favorite.isSelected = false
                        }
                        
                        if let StarCount = self.ServiceNInfoData["rat_total"] as? String {
                            self.lbl_StarCount.text = "(\(StarCount))"
                        }
                        else {
                            self.lbl_StarCount.text = "(0)"
                        }
                        if let star = self.ServiceNInfoData["rat_avg"] as? NSString {
                            self.lbl_StarView.setScore(Float(star.floatValue/10), withAnimation: false)
                        }else {
                            self.lbl_StarView.setScore(0, withAnimation: false)
                        }
                        
                        self.lbl_StylishName.text = (self.ServiceNInfoData["salon_name"] as? String)
                        self.lbl_Style.text = self.ServiceNInfoData["profession_name"] as? String
                        if let services = self.ServiceNInfoData["category_service"] as? NSArray {
                            self.ServiceArray = services
                            self.tblSalonDetail.reloadData()
                        }
                        self.InfoData = self.ServiceNInfoData["info"] as! NSDictionary
                        if let getSliderArray = self.ServiceNInfoData["salon_images"] as? NSArray {
                            for i in 0..<getSliderArray.count {
                                let dicData = getSliderArray[i] as! NSDictionary
                                self.Salon_Image.append(dicData.value(forKey: "image_url") as! String)
                            }
                            print("Salon_Image:=\(self.Salon_Image)")
                            self.imagePager.reloadData()
                        }
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
    func getSalonForReviewDetailTab(salonID:String) {
        //        flag_view  [0 = service and info details, 1 = offer details, 2= reviews details]
        
      if ReviewFalg.intValue >= 0 {
        
        BasicStuff.showLoader(self.view)
        let sendDict = NSMutableDictionary()
        sendDict.setValue("2", forKey: "flag_view")
        sendDict.setValue(Language.shared.Lang, forKey: "lang")
        sendDict.setValue(salonID, forKey: "salon_id")
        sendDict.setValue(ReviewFalg.stringValue, forKey: "offset")
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
                self.ReviewFalg = Obj.value(forKey: "next_offset") as! NSNumber
                if flag == 1 {
                    let arrayReview = Obj.value(forKey: "data") as! NSArray
                    for r in 0..<arrayReview.count {
                        self.ReviewArray.add(arrayReview[r] as! NSDictionary)
                    }
                    print("arrayReview:=\(self.ReviewArray)")
                    self.tblSalonDetail.reloadData()
                }
                else {
                    BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey: "msg") as! String)
                }
                
            }
            else {
                BasicStuff.showAlert(title: ALERT_TITLE, message: responceObj as! String)
                self.tblSalonDetail.reloadData()
            }
            
            BasicStuff.dismissLoader()
        }
        
      }else {
        refreshControl.endRefreshing()
        if  ReviewArray.count != 0 {
            tblSalonDetail.reloadData()
        }
        
      }
        
    }
    func getSalonForOfferListTab(salonID:String) {
        //        flag_view  [0 = service and info details, 1 = offer details, 2= reviews details]
        
        if OfferFalg.intValue >= 0 {
            
            BasicStuff.showLoader(self.view)
            
            let sendDict = NSMutableDictionary()
            sendDict.setValue("1", forKey: "flag_view")
            sendDict.setValue(Language.shared.Lang, forKey: "lang")
            sendDict.setValue(salonID, forKey: "salon_id")
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
                        self.tblSalonDetail.reloadData()
                    }
                    else {
                        BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey: "msg") as! String)
                    }
                    
                }
                else {
                    BasicStuff.showAlert(title: ALERT_TITLE, message: responceObj as! String)
                    self.tblSalonDetail.reloadData()
                }
                
                BasicStuff.dismissLoader()
            
            }
            
        }else {
            refreshControl.endRefreshing()
            if  OfferArray.count != 0 {
                tblSalonDetail.reloadData()
            }
            else {
                OfferFalg = 0
                self.getSalonForOfferListTab(salonID:salon_id)
            }
        }
    }
    func getInfoArray(dataInfo:NSDictionary?) {
        
        if dataInfo?.count != 0 {
            BasicStuff.showLoader(self.view)
            print("dataInfo:=\(dataInfo)")
            if InfoArrayData.count == 0 {
                if let getDiscription = dataInfo?.value(forKey: "description") as? String  {
                    
                    var AddDataDictionary = NSDictionary()
                    AddDataDictionary = ["description":getDiscription,"Key":"description"]
                    InfoArrayData.add(AddDataDictionary)
                }
                let getProgram = dataInfo?.value(forKey: "salon_program") as? NSArray
                if  getProgram != nil && getProgram?.count != 0{
                    let keyAddedDictionary = ["Key":"program","Title":"program"]
                    InfoArrayData.add(keyAddedDictionary)
                    
                    var AddDataDictionary = NSDictionary()
                    AddDataDictionary = ["salon_program":getProgram!,"Key":"program"]
                    InfoArrayData.add(AddDataDictionary)
                }
                
                if  let getLoction = dataInfo?.value(forKey: "address") as? String, let lattitude = dataInfo?.value(forKey: "latitude") as? String, let longitude = dataInfo?.value(forKeyPath: "longtitude") as? String {
                    
                    let keyAddedDictionary = ["Key":"location","Title":"location"]
                    InfoArrayData.add(keyAddedDictionary)
                    
                    var AddDataDictionary = NSDictionary()
                    AddDataDictionary = ["address":getLoction,"latitude":lattitude,"longtitude":longitude,"Key":"location"]
                    InfoArrayData.add(AddDataDictionary)
                }
                let utility = dataInfo?.value(forKey: "utility") as? NSArray
                if utility != nil && utility?.count != 0 {
                    
                    let keyAddedDictionary = ["Key":"utility","Title":"utility"]
                    InfoArrayData.add(keyAddedDictionary)
                    
                    var AddDataDictionary = NSDictionary()
                    AddDataDictionary = ["utility":utility!,"Key":"utility"]
                    InfoArrayData.add(AddDataDictionary)
                }
                let SocialMedia = dataInfo?.value(forKey: "social") as? NSDictionary
                if SocialMedia != nil && SocialMedia?.count != 0 {
                    let keyAddedDictionary = ["Key":"social","Title":"social"]
                    InfoArrayData.add(keyAddedDictionary)
                    
                    let AddDataDictionary = NSMutableDictionary()
                    AddDataDictionary.setValue(SocialMedia?.value(forKey: "whatsapp") as? String, forKey: "whatsapp")
                    AddDataDictionary.setValue(SocialMedia?.value(forKey: "twitter") as? String, forKey: "twitter")
                    AddDataDictionary.setValue(SocialMedia?.value(forKey: "facebook") as? String, forKey: "facebook")
                    AddDataDictionary.setValue(SocialMedia?.value(forKey: "google") as? String, forKey: "google")
                    AddDataDictionary.setValue(SocialMedia?.value(forKey: "pntrest") as? String, forKey: "pntrest")
                    AddDataDictionary.setValue(SocialMedia?.value(forKey: "youtube") as? String, forKey: "youtube")
                    AddDataDictionary.setValue(SocialMedia?.value(forKey: "instagram") as? String, forKey: "instagram")
                    AddDataDictionary.setValue(SocialMedia?.value(forKey: "website") as? String, forKey: "website")
                    AddDataDictionary.setValue("social", forKey: "Key")
                    InfoArrayData.add(AddDataDictionary)
                }
                let Team = dataInfo?.value(forKey: "salon_employee") as? NSArray
                if Team != nil && Team?.count != 0 {
                    let keyAddedDictionary = ["Key":"Team","Title":"Team"]
                    InfoArrayData.add(keyAddedDictionary)
                    
                    var AddDataDictionary = NSDictionary()
                    AddDataDictionary = ["salon_employee":Team!,"Key":"Team"]
                    InfoArrayData.add(AddDataDictionary)
                }
            print("InfoArrayData:=\(InfoArrayData)")
                self.tblSalonDetail.reloadData()
                BasicStuff.dismissLoader()
            }
            else {
                self.tblSalonDetail.reloadData()
                BasicStuff.dismissLoader()
            }
        }else {
            self.tblSalonDetail.reloadData()
        }
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
    
//    MARK:- Scrollview Delegate Method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if tblSalonDetail == scrollView {
            
        }else {
            if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
                //reach bottom
                print("Reach to bottom")
            }
            
            if (scrollView.contentOffset.y < 0){
                //reach top
                print("Reach to top")
            }
            
            if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
                //not top and not bottom
                print("not top and not bottom")
            }
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView != tblSalonDetail {
//            let lastKnowContentOfsset = scrollView.contentOffset.y
            print("lastKnowContentOfsset: ", scrollView.contentOffset.y)
            
            if scrollView.contentOffset.y > 0 {
                self.refreshTable()
//                Bottom Refresh
            }
            else {
//                Top Refresh
            }
            
            
        }
    }
    
    
    
    //    MARK:- Button Action
    @IBAction func btn_SelectionAction(_ sender:UIButton) {
        [btn_Service,btn_Offers,btn_Info,btn_Reviews].forEach({$0!.isSelected = false
            $0?.backgroundColor = UIColor.white})
        self.MainScrollview.bottomRefreshControl = nil
        if sender.tag == 0 {
            btn_Service.isSelected = true
            btn_Service.backgroundColor = UIColor.clear
            tblSalonDetail.reloadData()
        }
        else if sender.tag == 1 {
            btn_Offers.isSelected = true
            btn_Offers.backgroundColor = UIColor.clear
            self.MainScrollview.bottomRefreshControl = self.refreshControl
            self.getSalonForOfferListTab(salonID: salon_id)
            
        }
        else if (sender.tag == 2) {
            btn_Info.isSelected = true
            btn_Info.backgroundColor = UIColor.clear
            self.getInfoArray(dataInfo: InfoData)
          }
        else {
            btn_Reviews.isSelected = true
            btn_Reviews.backgroundColor = UIColor.clear
            self.MainScrollview.bottomRefreshControl = self.refreshControl
            self.getSalonForReviewDetailTab(salonID: salon_id)
            
        }
    }
    func btn_infoViewMoreAction(_ sender:UIButton) {
        
        let indexpath = sender.accessibilityElements?.first as! IndexPath
        let cell = tblSalonDetail.cellForRow(at: indexpath) as! SalonDetailCells
        print("cell.lbl_InfoDescription.numberOfLines:=\(cell.lbl_InfoDescription.numberOfLines)")
        print("InfonumberOfLine:=\(InfonumberOfLine)")
        if InfonumberOfLine == 0 {
            InfonumberOfLine = 2
        }
        else {
            InfonumberOfLine = 0
        }

        tblSalonDetail.reloadRows(at: [indexpath], with: UITableViewRowAnimation.none)
        
    }
    func btn_BookNowAction(_ sender:UIButton) {
        let indexpath = sender.accessibilityElements?.first as! IndexPath
        let DicData = ((self.ServiceArray[indexpath.section] as! NSDictionary).value(forKey: "service") as! NSArray)[indexpath.row] as! NSDictionary
        print("DicData:=\(DicData)")
        
        let getuserid = BasicStuff.getClienDetailWithoutCerdential(Key_IsLogin)
        if  getuserid == "0" {
//            BasicStuff.basic.storeBookingDetail.setValue(salon_id, forKey: "salon_id")
//            BasicStuff.basic.storeBookingDetail.setValue(DicData.value(forKey: "service_id") as! String, forKey: "service_id")
//            BasicStuff.basic.storeBookingDetail.setValue(salon_type, forKey: "salon_type")
            
            let dicData = ["salon_id":salon_id,"service_id":DicData.value(forKey: "service_id") as! String,"salon_type":salon_type]
            BasicStuff.basic.storeBookingDetail = dicData as NSDictionary!
            
            print("BasicStuff Dictionary:====> \(BasicStuff.basic.storeBookingDetail)")
            BasicStuff.basic.IsFromScreen = self.nibName!
            print("BasicStuff.basic.IsFromScreen:===> \(BasicStuff.basic.IsFromScreen)")
            
            let vc = LoginViewController()
            vc.salonDetailVC = self
            let navCV = UINavigationController(rootViewController: vc)
            self.present(navCV, animated: true, completion: nil)
            
            
//            let Login = LoginVC(nibName: "LoginVC", bundle: nil)
//            self.navigationController?.pushViewController(Login, animated: true)
            
        }else {
            let Booking = BookingVC(nibName: "BookingVC", bundle: nil)
            Booking.salon_id = salon_id
            Booking.service_id = DicData.value(forKey: "service_id") as! String
            Booking.salon_type = salon_type
            self.navigationController?.pushViewController(Booking, animated: true)
        }
        
    }
    func btn_BackAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func btn_ShareAction(_ sender:UIButton) {
        
        self.socialShare(sharingText: "Text", sharingImage: nil, sharingURL: nil)
    }
    
    @IBAction func btn_FavoriteAction(_ sender: UIButton) {
        
        if !(salon_id.isEmpty) {
            BasicStuff.showLoader(self.view)
            let sendDict = NSMutableDictionary()
            sendDict.setValue(Language.shared.Lang, forKey: "lang")
            sendDict.setValue(salon_id, forKey: "salon_id")
            sendDict.setValue(getUserIDwithOutCredential, forKey: "user_id")
            sendDict.setValue(getAccestokenwithOutCredential, forKey: "access_token")
            
            let manager = ServiceCall(URL: API_SalonFavorite)
            manager.setContentType(contentType: .multiPartForm)
            manager.setAuthorization(username: AUTHUSERNAME, password:AUTHPASSWORD)
            
            manager.POST(parameters: sendDict) { (success, responceObj) in
                
                SalonLog("responceObj:====>\(responceObj)")
                BasicStuff.dismissLoader()
                
                if success {
                    let Obj = responceObj as! NSDictionary
                    let flag = Obj.value(forKey: "flag") as! NSNumber
                    if flag == 1 {
                        BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey: "msg") as! String)
                        if self.btn_Favorite.isSelected == true {
                            self.btn_Favorite.isSelected = false
                        }
                        else {
                            self.btn_Favorite.isSelected = true
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
    }
    

//    MARK:- Info Social Button Action
    func btn_InfoSocialFBAction(_ sender:UIButton) {
        print("FB Click")
    }
    func btn_InfoSocialTwitterAction(_ sender:UIButton) {
        print("Twitter Click")
    }
    func btn_InfoSocialGpluseAction(_ sender:UIButton) {
        print("G+ Click")
    }
    func btn_InfoSocialPintrestAction(_ sender:UIButton) {
        print("Printrest Click")
    }
    func btn_InfoSocialInstaAction(_ sender:UIButton) {
        print("Insta Click")
    }
    func btn_InfoSocialYouTubeAction(_ sender:UIButton) {
        print("YouTube Click")
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
