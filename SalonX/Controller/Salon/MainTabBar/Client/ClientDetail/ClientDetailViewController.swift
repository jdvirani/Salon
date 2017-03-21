//
//  ClientDetailViewController.swift
//  SalonX
//
//  Created by DK on 11/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import SwiftyJSON

class ClientDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imgClientPicture: UIImageView!
    @IBOutlet weak var lblClientName: UILabel!
    @IBOutlet weak var lblAppointmentCount: UILabel!
    @IBOutlet weak var btnAppointment: UIButton!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewMail: UIView!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblTypeText: UILabel!
    @IBOutlet weak var lblClientType: UILabel!
    @IBOutlet weak var lblBirthdateText: UILabel!
    @IBOutlet weak var lblClientDOB: UILabel!
    @IBOutlet weak var lblNoteText: UILabel!
    @IBOutlet weak var txtViewNote: UITextView!
    
    @IBOutlet weak var viewSepetaor: UIImageView!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnFinished: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var clientDetail: JSON?
    
    var nextAppointmentList: [JSON] = []
    var finishedAppointment: [JSON] = []
    
    var nextOffset: Int = 0
    var finishedOffset: Int = 0
    
    convenience init() {
        self.init(nibName: R.nib.clientDetailVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        setUpTableUI()
        
        setupUI()
        
        getAppointmentList(appointmentType: "0")
        
        if clientDetail != nil {
            if let url = URL(string: clientDetail!["user_profile_pic"].stringValue) {
                imgClientPicture.sd_setImage(with: url, placeholderImage: R.image.placeholder__client(), options: .lowPriority)
            } else {
                imgClientPicture.image = R.image.placeholder__client()
            }
            
            lblClientName.text = "\(clientDetail!["first_name"].stringValue) \(clientDetail!["last_name"].stringValue)".trimmed()
            
            lblAppointmentCount.text = "\(clientDetail!["user_appointment"].stringValue) / \(clientDetail!["user_no_show"].stringValue)"
            lblPhoneNumber.text = clientDetail!["phone_no"].stringValue
            lblEmail.text = clientDetail!["email_address"].stringValue
            lblClientType.text = ":  \(clientDetail!["type"].stringValue)"
            
            let dateFmt = DateFormatter()
            dateFmt.dateFormat = "yyyy-MM-dd"
            
            if let dateString = dateFmt.date(from: clientDetail!["type"].stringValue) {
                dateFmt.dateFormat = "yyyy.MM.dd"
                 lblClientDOB.text = ":  \(dateFmt.string(from: dateString))"
            } else {
                lblClientDOB.text = ":  \(clientDetail!["dob"].stringValue)"
            }
            
            txtViewNote.text = clientDetail!["description"].stringValue
        }
        
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        
        setupBackButton()
        
        imgClientPicture.layer.cornerRadius = 3.0
        imgClientPicture.clipsToBounds = true
        
        btnAppointment.layer.cornerRadius = btnAppointment.frame.height / 2
        btnAppointment.clipsToBounds = true
        
        btnEditProfile.layer.cornerRadius = btnEditProfile.frame.height / 2
        btnEditProfile.clipsToBounds = true
        
        txtViewNote.addCornerAndBorderStyle()
        viewPhone.addCornerAndBorderStyle()
        viewMail.addCornerAndBorderStyle()
        
        btnNext.isSelected = true
        
        localizeUI()
    }
    
    func localizeUI() {
        self.title = LocalizedString(key: "client")
        btnAppointment.setTitle(LocalizedString(key:"appointment"), for: .normal)
        btnEditProfile.setTitle(LocalizedString(key: "editProfile"), for: .normal)
        lblTypeText.text = LocalizedString(key: "type")
        lblBirthdateText.text = LocalizedString(key:"birthdate")
        lblNoteText.text = LocalizedString(key: "note")
        btnNext.setTitle(LocalizedString(key:"next"), for: .normal)
        btnFinished.setTitle(LocalizedString(key:"finished"), for: .normal)
        
    }
    
    func setUpTableUI() {
        tableView.register(R.nib.clientAppointmentListCell(), forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 76.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
    }
}

//MARK: - Actions
extension ClientDetailViewController: ClientDetailChangedDelgate {
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        btnNext.isSelected = true
        btnFinished.isSelected = false
        tableView.reloadData()
        
        if sender.isSelected {
            print(nextAppointmentList.count)
            if nextAppointmentList.count <= 0 {
                if nextOffset == -1 {
                    return
                }
                getAppointmentList(appointmentType: "0")
            }
        }
    }
    
    @IBAction func btnFinished(_ sender: UIButton) {
        btnFinished.isSelected = true
        btnNext.isSelected = false
        tableView.reloadData()
        
        if sender.isSelected {
            print(finishedAppointment.count)
            if finishedAppointment.count <= 0 {
                if finishedOffset == -1 {
                    return
                }
                getAppointmentList(appointmentType: "1")
            }
        }
    }
    
    @IBAction func btnAppointmentTapped(_ sender: UIButton) {
        //TODO: - Redirect to Agenda
    }
    
    @IBAction func btnEditProfileTapped(_ sender: UIButton) {
        let vc = AddClientViewController()
        vc.clientDetail = clientDetail
        vc.clientDetailChangedDelgate = self
        vc.isEditMode = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func isDetailChanged(status: Bool) {
        if status {
            _ = navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isDetailChanged"), object: nil)
        }
    }
}

//MARK: - Network Helper
extension ClientDetailViewController {
    
    func getAppointmentList(appointmentType: String) {
        
        guard clientDetail != nil else { return }
        
        var param = [R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                     R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                     R.string.keys.lang() : Language.shared.Lang,
                     "flag_view" : "2",
                     "user_id" : clientDetail!["user_id"].stringValue,
                     "appointment_type" : appointmentType]
        
        if appointmentType == "0" {
            param["offset"] = "\(nextOffset)"
        } else {
            param["offset"] = "\(finishedOffset)"
        }
        
        if Rechability.isConnectedToNetwork() {
            print(param)
            BasicStuff.showLoader(self.view)
            ClientServices().clientRequest(param: param) { (result) in
                BasicStuff.dismissLoader()
                if let json = result.value {
                    if json[R.string.keys.flag()].stringValue == "1" {
                        if appointmentType == "0" {
                            self.nextOffset = json["next_offset"].intValue
                            print(self.nextOffset)
                            self.nextAppointmentList += json["data"].arrayValue
                            self.tableView.reloadData()
                        } else {
                            self.finishedOffset = json["next_offset"].intValue
                            print(self.finishedOffset)
                            self.finishedAppointment += json["data"].arrayValue
                            self                    .tableView.reloadData()
                        }
                        
                    } else if json[R.string.keys.flag()].stringValue == "0" {
                        if appointmentType == "0" {
                            self.nextOffset = -1
                        } else {
                            self.finishedOffset = -1
                            
                        }
                    }
                }
            }
        } else {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }  
}

//MARK: - Pagination
extension ClientDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            if btnNext.isSelected {
                if nextOffset == -1 {
                    return
                } else {
                    getAppointmentList(appointmentType: "0")
                }
            } else {
                if finishedOffset == -1 {
                    return
                } else {
                    getAppointmentList(appointmentType: "1")
                }
            }
        }
    }
}

//MARK: - Tableview methods
extension ClientDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if btnNext.isSelected {
            return nextAppointmentList.count
        } else {
            return finishedAppointment.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ClientAppointmentTableViewCell
        cell.selectionStyle = .none
        if btnNext.isSelected {
            let item = nextAppointmentList[indexPath.row]
            cell.lblServiceName.text = item["service_name"].stringValue
            cell.lblEmployeeName.text = "\(LocalizedString(key: "by")) \(item["name"].stringValue)"
            cell.lblDuration.text = "(\(item["duration"].stringValue))"
            cell.lblTime.text = "\(item["appointment_date"].stringValue) / \(item["start_time"].stringValue)"
            return cell
        } else {
            let item = finishedAppointment[indexPath.row]
            cell.lblServiceName.text = item["service_name"].stringValue
            cell.lblEmployeeName.text = "\(LocalizedString(key: "by")) \(item["name"].stringValue)"
            cell.lblDuration.text = "(\(item["duration"].stringValue))"
            cell.lblTime.text = "\(item["appointment_date"].stringValue) / \(item["start_time"].stringValue)"
            return cell
        }
    }
}
