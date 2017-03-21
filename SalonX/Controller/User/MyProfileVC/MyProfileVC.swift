//
//  MyProfileVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/18/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var img_User: UIImageView!
    @IBOutlet weak var txtUserFirstName: UITextField!
    @IBOutlet weak var txtUserLastName: UITextField!
    @IBOutlet weak var txtUserEmailID: UITextField!
    @IBOutlet weak var txtUserPhone: UITextField!
    @IBOutlet weak var btn_Submit: UIButton!
    
    var IsEditingImg = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        let buttonMenu = UIBarButtonItem(image: UIImage(named: "ic_menubar_header"), style: .plain, target: self, action: #selector(self.btn_LeftMenuAction)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.leftBarButtonItem  = buttonMenu
        
//        self.navigationController?.navigationBar.topItem?.title = "My Profile"
        
        let TapGusture = UITapGestureRecognizer.init(target: self, action: #selector(self.ProfileImageAction(_:)))
        TapGusture.numberOfTapsRequired = 1
        img_User.addGestureRecognizer(TapGusture)
        
        let Islogin = BasicStuff.getClienDetailWithoutCerdential(Key_IsLogin)
        
        if Islogin == "1" {
            txtUserFirstName.text = BasicStuff.getClienDetailWithoutCerdential("first_name")
            txtUserLastName.text = BasicStuff.getClienDetailWithoutCerdential("last_name")
            txtUserEmailID.text = BasicStuff.getClienDetailWithoutCerdential("email_address")
            txtUserPhone.text = BasicStuff.getClienDetailWithoutCerdential("phone_no")
            let imgUser = BasicStuff.getClienDetailWithoutCerdential("user_profile_pic")
            img_User.sd_setImage(with: URL.init(string: imgUser), placeholderImage: UIImage.init(named: "user_placeholder_salon_member"))
        }
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = LocalizedString(key: "lbl_MyProfileHeader")
        self.btn_Submit.setTitle(LocalizedString(key: "Comman_btn_Submit"), for: .normal)
    }
//    MARK:- ImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        img_User.image = selectedImage
        
        IsEditingImg = true
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("denied")
        IsEditingImg = false
        dismiss(animated: true, completion: nil)
    }
    //    MARK:- TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if txtUserPhone == textField{
            if range.location > 10 {
                return false
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
//    MARK:- Button Action
    @IBAction func btn_SubmitAction(_ sender: UIButton) {
        
        BasicStuff.showLoader(self.view)
        
        let getAccestokenwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("access_token")
        let getUserIDwithOutCredential = BasicStuff.getClienDetailWithoutCerdential("user_id")
        
        let sendDict = NSMutableDictionary()
        sendDict.setValue(getAccestokenwithOutCredential, forKeyPath: "access_token")
        sendDict.setValue(getUserIDwithOutCredential, forKeyPath: "user_id")
        sendDict.setValue(txtUserFirstName.text, forKeyPath: "firstname")
        sendDict.setValue(txtUserLastName.text, forKeyPath: "lastname")
        sendDict.setValue(txtUserEmailID.text, forKeyPath: "email")
        sendDict.setValue(txtUserPhone.text, forKeyPath: "mobile")
        sendDict.setValue(Language.shared.Lang, forKeyPath: "lang")
        
        SalonLog("sendDict===> \(sendDict)")
        
        let manager = ServiceCall(URL: API_Update_UserProfile)
        manager.setContentType(contentType: .multiPartForm)
        manager.setAuthorization(username: AUTHUSERNAME, password: AUTHPASSWORD)
        
        manager.POST(params: sendDict, appendBodyWithBlock: { (multiFormdata) in
            if IsEditingImg {
                
                let imgData = UIImageJPEGRepresentation(self.img_User.image!, 0.5)!
                multiFormdata.appendData(data: imgData, Key: "profile_pic", fileName: "Pic2.png")
            }
            
        }) { (success, responceObj) in
            
            
            SalonLog("responceObj:====>\(responceObj)")
            
            if success {
                let Obj = responceObj as! NSDictionary
                let flag = Obj.value(forKey: "flag") as! NSNumber
                if flag == 1 {
                    let getData = (Obj.value(forKey: "data") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    BasicStuff.removeClienDetailWithoutCerdential()
                    getData.setValue("1", forKey: Key_IsLogin)
                    getData.setValue(Obj.value(forKey: "access_token") as! String, forKey: "access_token")
                    BasicStuff.saveClienDetailWithoutCerdential(getData)
                    BasicStuff.showAlert(title: ALERT_TITLE, message: Obj.value(forKey: "msg") as! String)
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
    
    func ProfileImageAction(_ sender:UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: nil, message: "Choose Option", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Camera selected")
            //Code for Camera
            //cameraf
            if Platform.isSimulator {
                print("you have open in simulator, please access in real device")
            }
            else {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = true
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            }
            
        })
        alert.addAction(UIAlertAction(title: "Photo library", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Photo selected")
            //Code for Photo library
            //photolibaryss
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
            //Code for Photo library
            //photolibaryss
            self.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
        
        
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
