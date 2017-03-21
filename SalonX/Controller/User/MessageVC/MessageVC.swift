//
//  MessageVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/25/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class MessageVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var tblMessage: UITableView!
    @IBOutlet weak var txt_Message: UITextField!
    @IBOutlet weak var btn_Send: UIButton!
    
    @IBOutlet weak var constant_ViewBottom: NSLayoutConstraint! // 22
    
    var ArrayMessages = NSMutableArray()
    var Offset:NSNumber = 0
    let refreshControl = UIRefreshControl()
    
    var salonId:String!
    var appointmentID:String!
    
    
    var dateFormetter = DateFormatter()
    
    
    let getAccestokenwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("access_token")
    let getUserIDwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("user_id")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.navigationController?.navigationBar.isHidden = false
        setupBackButton()
    
//        self.title = "Message"
    
        dateFormetter.dateFormat = "hh:mm a"
        
        // SenderDictionary Comman Data
        
        
        let SenderNib = UINib(nibName: "MessageSenderCell", bundle: nil)
        tblMessage.register(SenderNib, forCellReuseIdentifier: "MessageSenderCell")
    
        let RecieverNib = UINib(nibName: "MessageRecieverCell", bundle: nil)
        tblMessage.register(RecieverNib, forCellReuseIdentifier: "MessageRecieverCell")
    
        refreshControl.addTarget(self, action: #selector(self.refreshTable), for: .valueChanged)
        self.tblMessage.bottomRefreshControl = refreshControl
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        refreshTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = LocalizedString(key: "lbl_MessageHeader")
        txt_Message.placeholder = LocalizedString(key: "txtPlace_MessageType")
        btn_Send.setTitle(LocalizedString(key: "Comman_btn_Send"), for: .normal)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func refreshTable(){
        refreshControl.beginRefreshing()
        self.getMessageList(SalonId: salonId, AppointmentID: appointmentID)
    }
    

//    MARK:- Tableview Delegate & DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrayMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DicData = ArrayMessages[indexPath.row] as! NSDictionary
        let issender = DicData.value(forKey: "is_read") as! String
        
        if issender == "0" {
// ========= Sender =======
            let cell = tblMessage.dequeueReusableCell(withIdentifier: "MessageSenderCell")  as! MessageCells
            
//            cell.constantlblMessageWidthGraterthanEqual.constat = self.view.frame.size.width - 178
            if let SenderImg = DicData.value(forKey: "user_image") as? String {
                cell.Img_Sender.sd_setImage(with: URL.init(string: SenderImg), placeholderImage: UIImage.init(named: "user_placeholder_side_menu"))
            }
            
            cell.lbl_SenderName.text = DicData.value(forKey: "user_name") as? String
            cell.lbl_SenderTime.text = DicData.value(forKey: "message_date") as? String
            cell.lbl_SenderMessage.text = DicData.value(forKey: "message") as? String
            return cell
        }
        else {
// ========= Receiver =======
            let cell = tblMessage.dequeueReusableCell(withIdentifier: "MessageRecieverCell")  as! MessageCells
            if let SenderImg = DicData.value(forKey: "user_image") as? String {
                cell.Img_Reciver.sd_setImage(with: URL.init(string: SenderImg), placeholderImage: UIImage.init(named: "user_placeholder_side_menu"))
            }
//            cell.Img_Reciver.image = 
            cell.Img_bgText.layer.borderColor = UIColor.lightGray.cgColor
            cell.lbl_ReciverName.text = DicData.value(forKey: "user_name") as? String
            cell.lbl_ReciverTime.text = DicData.value(forKey: "message_date") as? String
            cell.lbl_ReciverMessage.text =
                DicData.value(forKey: "message") as? String
            
            return cell
        }
    
    }
    
    func getMessageList(SalonId:String,AppointmentID:String) {
        
        
//        lang [0 = Eng, 1 = romanian]
//        user_id
//        access_token
//        flag_view [0 = chat history, 1 = send message]
//        offset [passed if flag_view = 0]
//        appointment_id
//        salon_id
//        message [passed if flag_view =1]

      if Offset.intValue >= 0 {
        
        BasicStuff.showLoader(self.view)
        
        let sendDict = NSMutableDictionary()
        sendDict.setValue(Language.shared.Lang, forKey: "lang")
        sendDict.setValue(getUserIDwithOutCredential, forKey: "user_id")
        sendDict.setValue(getAccestokenwithOutCredential, forKey: "access_token")
        sendDict.setValue(Offset.stringValue, forKey: "offset")
        sendDict.setValue(SalonId, forKey: "salon_id")
        sendDict.setValue(AppointmentID, forKey: "appointment_id")
        sendDict.setValue("0", forKey: "flag_view") //0 = chat historyappointment
        
        SalonLog("sendDict:====>\(sendDict)")
        let manager = ServiceCall(URL: API_SalonChatAppointment)
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
                    let dataReciver = Obj.value(forKey: "data") as! NSArray
                    dataReciver.forEach({self.ArrayMessages.add($0)})
                    self.tblMessage.reloadData()
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
            self.refreshControl.endRefreshing()
       }
        
    }
    func SendMessage(SalonId:String,AppointmentID:String,message:String) {
        
            BasicStuff.showLoader(self.view)
            let sendDict = NSMutableDictionary()
            sendDict.setValue(Language.shared.Lang, forKey: "lang")
            sendDict.setValue(getUserIDwithOutCredential, forKey: "user_id")
            sendDict.setValue(getAccestokenwithOutCredential, forKey: "access_token")
//            sendDict.setValue(Offset.stringValue, forKey: "offset")
            sendDict.setValue(SalonId, forKey: "salon_id")
            sendDict.setValue(AppointmentID, forKey: "appointment_id")
            sendDict.setValue(message, forKey: "message")
            sendDict.setValue("1", forKey: "flag_view") //0 = chat historyappointment
            
            SalonLog("sendDict:====>\(sendDict)")
            let manager = ServiceCall(URL: API_SalonChatAppointment)
            manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
            manager.setContentType(contentType: .multiPartForm)
            
            manager.POST(parameters: sendDict) { (success, responceObj) in
                
                SalonLog("responceObj:====>\(responceObj)")
                
                if success {
                    let Obj = responceObj as! NSDictionary
                    let flag = Obj.value(forKey: "flag") as! NSNumber
                    
                    if flag == 1 {
                        let dateTime = self.dateFormetter.string(from: Date())
                        print("dateTime:=\(dateTime)")
                        let senderDictionary = NSMutableDictionary()
                        let First = BasicStuff.getClienDetailWithoutCerdential("first_name")
                        let Last = BasicStuff.getClienDetailWithoutCerdential("last_name")
                        senderDictionary.setValue("\(First) \(Last)", forKey: "user_name")
                        senderDictionary.setValue(message, forKey: "message")
                        senderDictionary.setValue(dateTime, forKey: "message_date")
                        senderDictionary.setValue("0", forKey: "is_read")
                        senderDictionary.setValue(BasicStuff.getClienDetailWithoutCerdential("user_profile_pic"), forKey: "user_image")
                        self.ArrayMessages.add(senderDictionary)
                        self.txt_Message.text = ""
                        self.tblMessage.reloadData()
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
    
    
//    MARK:- TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
//    MARK:- KeyBord Notifiction Action 
    func keyboardWillShow(_ notification: NSNotification){
        // Do something here
        if let keyboardRectValue = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardRectValue.height
            print("keyboardHeight:=\(keyboardHeight)")
            constant_ViewBottom.constant = keyboardHeight
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification){
        // Do something here
        constant_ViewBottom.constant = 20
    }
    
    
//    MARK:- Button Action
    @IBAction func btn_SendAction(_ sender: UIButton) {
        
        if !(txt_Message.text?.isEmpty)! {
            self.SendMessage(SalonId: salonId, AppointmentID: appointmentID, message: txt_Message.text!)
            
        }
        else {
            print("Please Enter Message")
        }
        
    }
    
    func btn_backAction(_ sender: UIButton) {
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
