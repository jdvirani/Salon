//
//  ManageProgramViewController.swift
//  SalonX
//
//  Created by DK on 17/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import SwiftyJSON

var selectedTextBoxTag = 0

class ManageProgramViewController: UIViewController {
    
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblOpen: UILabel!
    @IBOutlet weak var lblClose: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewDatePicker: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var topDatePicker: NSLayoutConstraint!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var btnDoneDatePicker: UIButton!
    @IBOutlet weak var btnCancelDatePicker: UIButton!
    @IBOutlet weak var stkButtons: UIStackView!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var pushType: PushType = .login
    
    var salonProgramList: [JSON] = []
    
    var days: [String] = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    
    convenience init() {
        self.init(nibName: R.nib.manageProgramVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        if pushType == .login {
            setupBackButton()
            btnNext.isHidden = true
        } else {
            self.navigationItem.hidesBackButton = true
            btnSave.isHidden = true
            btnCancel.isHidden = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(openDatePickerView), name: NSNotification.Name(rawValue: "openDatePicker"), object: nil)
        
        selectedTextBoxTag = 0
        
        viewButtons.borderWidth = 1.0
        viewButtons.borderColor = R.color.salonX.seperator()
        
        localizeUI()
        
        setupTableUI()
        
        heightTableView.constant = 62.0 * 7.0
        
        dismissView()
        
        getProgramList()
    }
    
    func localizeUI() {
        self.title = LocalizedString(key: "manageProgram")
        lblDays.text = LocalizedString(key: "days")
        lblOpen.text = LocalizedString(key: "open")
        lblClose.text = LocalizedString(key: "close")
        btnSave.setTitle(LocalizedString(key: "save"), for: .normal)
        btnCancel.setTitle(LocalizedString(key: "cancel"), for: .normal)
        btnCancelDatePicker.setTitle(LocalizedString(key: "cancel"), for: .normal)
        btnDoneDatePicker.setTitle(LocalizedString(key: "done"), for: .normal)
        btnNext.setTitle(LocalizedString(key: "next"), for: .normal)
    }
    
    func setupTableUI() {
        tableView.register(R.nib.manageProgramCell(), forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 62.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
    }
}

//MARK: - Actions
extension ManageProgramViewController {
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        
        let selectedProgramArray = NSMutableArray()

        for i in 0..<7 {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! ManageProgramTableViewCell
            
            if cell.btnCheckBox.isSelected {
                print("Start Time =>\(cell.txtStartTime.text!) To Close Time=>\(cell.txtCloseTime.text!)")
                var program = NSDictionary()
                
                if i < 6 {
                    program = ["is_day" : "\(i + 1)","start_time" : "\(cell.txtStartTime.text!) \(cell.lblStartTime.text!.uppercased())" ,"end_time" :"\(cell.txtCloseTime.text!) \(cell.lblCloseTime.text!.uppercased())" ]
                } else {
                    program = ["is_day" : "0","start_time" : "\(cell.txtStartTime.text!) \(cell.lblStartTime.text!.uppercased())" ,"end_time" :"\(cell.txtCloseTime.text!) \(cell.lblCloseTime.text!.uppercased())"]
                }
                
                selectedProgramArray.add(program)
            }
        }
        
        if pushType == .signup {
            if selectedProgramArray.count > 0 {
                print(selectedProgramArray)
                saveProgramList(programParam: selectedProgramArray)
            } else {
                 BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "pleaseAddAtLeastOneDayProgram"))
            }
        } else {
            print(selectedProgramArray)
            saveProgramList(programParam: selectedProgramArray)
        }

    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
       _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDoneDatePickerTapped(_ sender: UIButton) {
        
        print(datePicker.date)
        let formatter = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
        
        let dateFmt = DateFormatter()
        
        var dateString = ""
        
        if formatter.contains("a") {
            dateFmt.dateFormat = "hh:mm a"
            dateString = dateFmt.string(from: datePicker.date)
        } else {
            print("\(datePicker.date)")
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd hh:mm:ss ZZZZ"
            if let newDate = dateFormat.date(from: "\(datePicker.date)") {
                print(newDate)
                dateFormat.dateFormat = "hh:mm a"
                let newString = dateFormat.string(from: newDate)
                
                if let hour = Int(newString.components(separatedBy: ":")[0]) {
                    if hour > 12 {
                        dateString = "\(hour - 12):\(newString.components(separatedBy: ":")[1]) pm"
                    } else {
                        dateString = "\(hour):\(newString.components(separatedBy: ":")[1]) am"
                    }
                }
            }
        }

        print(dateString)
        
        var row = 0
        let indexPath: IndexPath?
        
        if selectedTextBoxTag != 0 {
            if selectedTextBoxTag < 999 {
                // Start Time textbox
                row = selectedTextBoxTag - 1
                indexPath = IndexPath(row: row, section: 0)
                if indexPath != nil {
                    let cell = tableView.cellForRow(at: indexPath!) as! ManageProgramTableViewCell
                    cell.txtStartTime.text = dateString.components(separatedBy: " ")[0]
                    cell.lblStartTime.text = dateString.components(separatedBy: " ")[1].lowercased()
                }
                
            } else {
                row = (selectedTextBoxTag - 1) / 1000
                indexPath = IndexPath(row: row, section: 0)
                let cell = tableView.cellForRow(at: indexPath!) as! ManageProgramTableViewCell
                cell.txtCloseTime.text = dateString.components(separatedBy: " ")[0]
                cell.lblCloseTime.text = dateString.components(separatedBy: " ")[1].lowercased()
            }
        }
        
        dismissView()
    }
    
    @IBAction func btnCancelDatePickerTapped(_ sender: UIButton) {
        
        dismissView()
    }
}

//MARK: - Network Helper
extension ManageProgramViewController {
    
    func getProgramList() {
        
        let param = [ R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                      R.string.keys.lang() : Language.shared.Lang,
                      R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                      "flag_view" : "0"]
        
        if Rechability.isConnectedToNetwork() {
            BasicStuff.showLoader(self.view)
            
            ManageProgramService().manageProgramRequest(param: param, completion: { (result) in
                
                BasicStuff.dismissLoader()
                
                print(result.value)
                if let json = result.value {
                    if json[R.string.keys.flag()].stringValue == "1" {
                        self.salonProgramList = json["data"].arrayValue
                        print(self.salonProgramList)
                        self.tableView.reloadData()
                    }
                }
            })
        } else  {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }
    
    func saveProgramList(programParam: NSMutableArray) {
        
         if Rechability.isConnectedToNetwork() {
            
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: programParam,
                options: []) {
                if let theJSONText = String(data: theJSONData,
                                            encoding: .ascii) {
                    print("JSON string = \(theJSONText)")
                    
                    let param = [ R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                                  R.string.keys.lang() : Language.shared.Lang,
                                  R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                                  "flag_view" : "1",
                                  "salon_program" : theJSONText]
                    
                    print(param)
                    
                    BasicStuff.showLoader(self.view)
                    
                    ManageProgramService().manageProgramRequest(param: param, completion: { (result) in
                        
                        BasicStuff.dismissLoader()
                        print(result.value)
                        
                        if let json = result.value {
                            if json[R.string.keys.flag()].stringValue == "1" {

                                if self.pushType == .signup {
                                    UserDefaults.standard.set(true, forKey:R.string.keys.isUserSignIn())
                                    appDelegate.configureWindowAndMakeVisible(rootVC: SalonMainTabBarController())
                                } else {
                                    
                                     BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: json[R.string.keys.msg()].stringValue)
                                }
                                
                            }
                        }
                    }) //end of Service Call
                }
            } //end of JSON Serialization porcess
        } else  {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
    }
}

extension ManageProgramViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ManageProgramTableViewCell
        cell.selectionStyle = .none
        cell.btnCheckBox.tag = indexPath.row
        cell.btnCheckBox.addTarget(self, action: #selector(self.btnCheckboxTapped(_:)), for: .touchUpInside)
        
        if salonProgramList.contains(where: { $0["day_name"].stringValue == days[indexPath.row] }) {
            
            cell.btnCheckBox.isSelected = true
            [cell.txtStartTime,cell.txtCloseTime,cell.btnCloseTime,cell.btnCloseTime].forEach({ $0.isEnabled = true })
            
            let dayName = days[indexPath.row]
            
            if let index = salonProgramList.index(where: { $0["day_name"].stringValue == dayName }) {
                let startTime = salonProgramList[index]["start_time"].stringValue
                let endTime = salonProgramList[index]["end_time"].stringValue
                
                cell.txtStartTime.text = startTime.components(separatedBy: " ")[0]
                cell.lblStartTime.text = startTime.components(separatedBy: " ")[1].lowercased()
                
                cell.txtCloseTime.text = endTime.components(separatedBy: " ")[0]
                cell.lblCloseTime.text = endTime.components(separatedBy: " ")[1].lowercased()
                
            }
        }
        
        cell.lblDayName.text = days[indexPath.row]
        cell.txtStartTime.tag = indexPath.row + 1
        cell.txtCloseTime.tag = (indexPath.row + 1) * 1000
        return cell
    }
    
    func btnCheckboxTapped(_ sender: UIButton) {
        print(sender.tag)
        
        let cell = tableView.cellForRow(at: IndexPath(row:sender.tag, section: 0)) as! ManageProgramTableViewCell
        
        if sender.isSelected {
            cell.btnCheckBox.isSelected = false
            cell.txtStartTime.isEnabled = false
            cell.btnStartTime.isEnabled = false
            cell.txtCloseTime.isEnabled = false
            cell.btnCloseTime.isEnabled = false
            
        } else {
            cell.btnCheckBox.isSelected = true
            cell.txtStartTime.isEnabled = true
            cell.btnStartTime.isEnabled = true
            cell.txtCloseTime.isEnabled = true
            cell.btnCloseTime.isEnabled = true
        }
    }
}

//MARK: PickerView functions
extension ManageProgramViewController {
    
    func dismissView() {
        scrollView.isScrollEnabled = true
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3)
        {
            self.topDatePicker.constant = UIScreen.main.bounds.height
            self.view.layoutIfNeeded()
        }
        viewButtons.isHidden = true
        // stkButtons.isHidden = false
        self.view.layoutIfNeeded()
        
        UIView.commitAnimations()
        
        selectedTextBoxTag = 0
    }
    
    func openDatePickerView() {
        
        datePicker.datePickerMode = .time
        
        scrollView.isScrollEnabled = false
        
        if selectedTextBoxTag > 999 {
            let row = (selectedTextBoxTag - 1) / 1000
            
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! ManageProgramTableViewCell
            
            let dateFmt = DateFormatter()
            dateFmt.dateFormat = "HH:mm a"
            
            let time = "\(cell.txtStartTime.text!) \(cell.lblStartTime.text!.uppercased())"
            
            if let dateFromTime = dateFmt.date(from: time) {
                var finalDateComponents = DateComponents()
                
                let userCalendar = Calendar.current
                
                let timeComponent = userCalendar.dateComponents([.hour, .minute, .second], from: dateFromTime)
                
                finalDateComponents.year = userCalendar.component(.year, from: Date())
                finalDateComponents.month = userCalendar.component(.month, from: Date())
                finalDateComponents.day = userCalendar.component(.day, from: Date())
                finalDateComponents.hour = timeComponent.hour
                finalDateComponents.minute = timeComponent.minute
                finalDateComponents.second = timeComponent.second
                
                if let finalDate = userCalendar.date(from: finalDateComponents) {
                    datePicker.minimumDate = finalDate
                    print(finalDate)
                }
            }
        }
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3)
        {
            if self.pushType == .signup {
                self.topDatePicker.constant = UIScreen.main.bounds.height - 180 - 49
                self.view.layoutIfNeeded()
            } else {
                self.topDatePicker.constant = UIScreen.main.bounds.height - 140 - 49
                self.view.layoutIfNeeded()
            }
            
        }
        viewButtons.isHidden = false
        // stkButtons.isHidden = true
        self.view.layoutIfNeeded()
        
        UIView.commitAnimations()
    }
    
}
