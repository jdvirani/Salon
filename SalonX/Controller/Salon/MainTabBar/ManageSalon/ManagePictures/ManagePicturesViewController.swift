//
//  ManagePicturesViewController.swift
//  SalonX
//
//  Created by DK on 17/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ManagePicturesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomOfCollectionView: NSLayoutConstraint!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    
    let imagePicker = UIImagePickerController()
    
    var pushType: PushType = .login
    
    var salonImageList: [JSON] = []
    
    var isNewImage = true
    var selectedEditImageID: String?
    
    convenience init() {
        self.init(nibName: R.nib.managePicturesVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if pushType == .login {
            setupBackButton()
            buttonHeight.constant = 0.0
            bottomOfCollectionView.constant = 0.0
            btnSave.isHidden = true
        } else {
            self.navigationItem.hidesBackButton = true
            bottomOfCollectionView.constant = 40.0
            buttonHeight.constant = 40.0
            btnSave.isHidden = false
        }
        
        self.imagePicker.delegate = self
        
        setupUI()
        setupCollectionViewUI()
        
        fetchSalonImages()
        // Do any additional setup after loading the view.
    }
    
    func setupCollectionViewUI() {
        collectionView.register(R.nib.salonPictureCell(), forCellWithReuseIdentifier: "cell")
    }
    
    func setupUI() {
        self.title = LocalizedString(key: "managePicture")
    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        if !salonImageList.isEmpty {
            let vc = ManageServiceViewController()
            vc.pushType = .signup
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
             BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "addAtleastOneSalonPicture"))
        }
    }
}

//MARK: Network Helper
extension ManagePicturesViewController {
    
    func fetchSalonImages() {
        
        let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.saveSalonPictureURL()
        
        let param = [R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                     R.string.keys.access_token() : getUserDetail(R.string.keys.access_token())
            ,
                     "flag_view" : "0",
                     R.string.keys.lang() : Language.shared.Lang] as [String : Any]
        
         if Rechability.isConnectedToNetwork() {
            
            BasicStuff.showLoader(self.view)
            Alamofire.request(kURL, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: R.string.keys.authUsername(), password: R.string.keys.authPassword()).responseSwiftyJSON { (response) in
                print(response)
                BasicStuff.dismissLoader()
                
                if let json = response.result.value {
                    if json[R.string.keys.flag()].stringValue == "1" {
                        self.salonImageList = json["data"].arrayValue
                        print(self.salonImageList)
                        self.collectionView.reloadData()
                        
                    }
                }
            }
        }
    }
    
    func saveImages(imageId: String, image: UIImage) {
        
        let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.saveSalonPictureURL()
        
        let param = [R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                     R.string.keys.access_token() : getUserDetail(R.string.keys.access_token())
            ,
                     "flag_view" : "1",
                     R.string.keys.lang() : Language.shared.Lang,
                     "is_del" : "0",
                     "image_id" : imageId]
        
         if Rechability.isConnectedToNetwork() {
            
            BasicStuff.showLoader(self.view)
            
            print(param)
            
            let manager = ServiceCall(URL: kURL)
            manager.setContentType(contentType: .multiPartForm)
            manager.setAuthorization(username: R.string.keys.authUsername(), password: R.string.keys.authPassword())
            manager.POST(params: param as NSDictionary, appendBodyWithBlock: { (multiPartData) in
                
                if let imageData = UIImageJPEGRepresentation(image, 0.6) {
                    multiPartData.appendData(data: imageData, Key: "salon_picture", fileName: "file.png")
                }
                
            }) { (status, response) in
                print(response)
                BasicStuff.dismissLoader()
                if status {
                    self.fetchSalonImages()
            
                }
            }
            
         } else {
             BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }
    
    func deleteImage(index: Int) {
        let alertController = UIAlertController(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "confirmDeleteSalonPicureMessage"), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: LocalizedString(key: "Ok"), style: .default) { (action) in
            
            let imageID = self.salonImageList[index]["salon_picture_id"].stringValue
            
            let kURL = R.string.webUrl.baseUrl() + R.string.webUrl.saveSalonPictureURL()
            
            let param = [R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                         R.string.keys.access_token() : getUserDetail(R.string.keys.access_token())
                ,
                         "flag_view" : "1",
                         R.string.keys.lang() : Language.shared.Lang,
                         "is_del" : "1",
                         "image_id" : imageID]
            
             if Rechability.isConnectedToNetwork() {
                
                BasicStuff.showLoader(self.view)
                print(param)
                
                Alamofire.request(kURL, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).authenticate(user: R.string.keys.authUsername(), password: R.string.keys.authPassword()).responseSwiftyJSON { (response) in
                    print(response)
                    
                    BasicStuff.dismissLoader()
                    
                    if let json = response.result.value {
                        if json[R.string.keys.flag()].stringValue == "1" {
                            self.salonImageList.remove(at: index)
                            self.collectionView.reloadData()
                        }
                    }
                    
                }
             } else {
                 BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
            }
            
        }
        
        let cancelAction = UIAlertAction(title: LocalizedString(key: "cancel"), style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    
    }
  
}

extension ManagePicturesViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return salonImageList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SalonPictureCollectionViewCell
        
        cell.setCellUI()
        
        if salonImageList.count == 0 {
            cell.imgSalonPicuture.image = R.image.img_upload_photo()
            cell.btnDelete.isHidden = true
            cell.btnEditPlaceHolder.isHidden = true
            return cell
        } else if indexPath.row < salonImageList.count {

            let imgURL = URL(string: salonImageList[indexPath.row]["image_url"].stringValue)
            
            cell.imgSalonPicuture.sd_setImage(with: imgURL! , placeholderImage: R.image.placeholder__client(), options: SDWebImageOptions.highPriority)
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.isHidden = false
            cell.btnDelete.addTarget(self, action: #selector(self.btnDeleteTapped(_:)), for: .touchUpInside)
            cell.btnEditPlaceHolder.isHidden = false
            return cell
        } else {
            cell.imgSalonPicuture.image = R.image.img_upload_photo()
            cell.btnDelete.isHidden = true
            cell.btnEditPlaceHolder.isHidden = true
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == salonImageList.count {
            isNewImage = true
           openImagePicker()
        } else {
            
            selectedEditImageID = salonImageList[indexPath.row]["salon_picture_id"].stringValue
            isNewImage = false
            openImagePicker()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       // return CGSize(width: ((UIScreen.main.bounds.width / 2) - 10), height: ((UIScreen.main.bounds.width / 2) - 10))
        
        return CGSize(width: ((collectionView.frame.width / 2) - 5), height: ((collectionView.frame.width / 2) - 5))
    }

    
    func openImagePicker() {
        let imageOptionController = UIAlertController(title: "SalonX", message: "Please choose the image.", preferredStyle: .actionSheet)
        imageOptionController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                self.imagePicker.delegate = self
                self.imagePicker.modalPresentationStyle = .overCurrentContext
                self.tabBarController?.tabBar.isHidden = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }))
        
        imageOptionController.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
            {
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.allowsEditing = true
                self.imagePicker.delegate = self
                self.imagePicker.modalPresentationStyle = .overCurrentContext
                self.tabBarController?.tabBar.isHidden = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }))
        
        imageOptionController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if pushType == .signup {
            present(imageOptionController, animated: true, completion: nil)
        } else {
             tabBarController?.present(imageOptionController, animated: true, completion: nil)
        }
        
       
    }
    
    func btnDeleteTapped(_ sender: UIButton) {
        
        print(sender.tag)
        
        deleteImage(index: sender.tag)
    }
    
}

extension ManagePicturesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if isNewImage {
            saveImages(imageId: "0", image: image)
        } else {
            saveImages(imageId: selectedEditImageID!, image: image)
        }
        
        self.tabBarController?.tabBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.tabBarController?.tabBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
}


