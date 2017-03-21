//
//  ReportViewController.swift
//  SalonX
//
//  Created by DK on 20/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    
    // Profile activity
    @IBOutlet weak var lblProfileActivity: UILabel!
    @IBOutlet weak var lblViews: UILabel!
    @IBOutlet weak var lblViewText: UILabel!
    @IBOutlet weak var lblAppointments: UILabel!
    @IBOutlet weak var lblAppointmentsText: UILabel!
    @IBOutlet weak var lblFavorite: UILabel!
    @IBOutlet weak var lblFavoriteText: UILabel!
    @IBOutlet weak var lblBookedPrice: UILabel!
    @IBOutlet weak var lblDollersBookedText: UILabel!
    
    @IBOutlet weak var lblStatisticsHeader: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Appointment
    @IBOutlet weak var lblAppointmentHeader: UILabel!
    @IBOutlet weak var tblAppointment: UITableView!
    @IBOutlet weak var tblAppointmentHeight: NSLayoutConstraint!
    
    //TOP Service
    @IBOutlet weak var lblTopService: UILabel!
    @IBOutlet weak var tblTopServices: UITableView!
    @IBOutlet weak var tblTopServicesHeight: NSLayoutConstraint!
    
    //Employee
    @IBOutlet weak var lblEmployees: UILabel!
    @IBOutlet weak var tblEmployees: UITableView!
    @IBOutlet weak var tblEmployeesHeight: NSLayoutConstraint!

    //SMS COUNTOR
    @IBOutlet weak var lblSMSCounter: UILabel!
    
    @IBOutlet weak var lblFreeSMS: UILabel!
    @IBOutlet weak var lblFreeSMSText: UILabel!
    @IBOutlet weak var consumedSMS: UILabel!
    @IBOutlet weak var lblconsumedSMS: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTotalText: UILabel!
    
    @IBOutlet weak var btnExportReport: UIButton!

    var employeeDetail: [NSDictionary] = [["name" : "Mircea Radu","self-created" : "500","salonx" : "700","lastMinute" : "800","total" : "2000"],
        ["name" : "Alina miron","self-created" : "500","salonx" : "700","lastMinute" : "800","total" : "2000"],
        ["name" : "Loana Savau","self-created" : "500","salonx" : "700","lastMinute" : "800","total" : "2000"] ]
    
    let monthName = ["January","May", "June","July","September","Octomber","December"]
    
    
    convenience init() {
        self.init(nibName: R.nib.reportVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        localizeUI()
        
        setupTableUI()
        
        setupCollectionViewUI()
    }
    
    override func viewDidLayoutSubviews() {
        
        tblAppointmentHeight.constant = tblAppointment.contentSize.height
        tblTopServicesHeight.constant = tblTopServices.contentSize.height
        tblEmployeesHeight.constant = tblEmployees.contentSize.height
    
        self.view.layoutIfNeeded()
        
    }
    
    func localizeUI() {
        self.title = LocalizedString(key: "report")
        
        //Profile Activity
        lblProfileActivity.text = LocalizedString(key: "profileActivity")
        lblStatisticsHeader.text = LocalizedString(key: "statistics")
        lblViewText.text = LocalizedString(key: "views")
        lblAppointmentsText.text = LocalizedString(key: "appointments")
        lblFavoriteText.text = LocalizedString(key: "favorite")
        lblDollersBookedText.text = LocalizedString(key: "dollersBooked")
        
        
        lblAppointmentHeader.text = LocalizedString(key: "appointmentHeader")
        lblTopService.text = LocalizedString(key: "topServices")
        lblEmployees.text = LocalizedString(key: "employees")
        
        //SMS counter
        lblSMSCounter.text = LocalizedString(key: "smsCounter")
        lblFreeSMSText.text = LocalizedString(key: "freeSMS")
        lblconsumedSMS.text = LocalizedString(key: "smsConsumed")
        lblTotalText.text = LocalizedString(key: "total")
        
        btnExportReport.setTitle(LocalizedString(key: "exportReport"), for: .normal)
    }
    
    func setupTableUI() {
        
        tblAppointment.register(R.nib.reportDetailCell(), forCellReuseIdentifier: "detailCell")
        
        tblTopServices.register(R.nib.reportDetailCell(), forCellReuseIdentifier: "detailCell")
        
        tblEmployees.register(R.nib.employeeReportDetailCell(), forCellReuseIdentifier: "employeeCell")
        
        [tblEmployees,tblAppointment,tblTopServices].forEach({ $0?.estimatedRowHeight = 30.0
            $0?.rowHeight = UITableViewAutomaticDimension
            $0?.separatorStyle = .none
            $0?.delegate = self
            $0?.dataSource = self
        })
        
    }
    
    func setupCollectionViewUI() {
        collectionView.register(R.nib.monthStatisticCell(), forCellWithReuseIdentifier: "cell")
    }
    
   
}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblAppointment {
            return 5
            
        } else if tableView == tblTopServices {
            return 7
            
        } else if tableView == tblEmployees {
            
            return 4
            
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblAppointment {
            let detailCell = tblAppointment.dequeueReusableCell(withIdentifier: "detailCell") as! ReportDetailTableViewCell
            detailCell.selectionStyle = .none
            
            if indexPath.row == 0 {
                [detailCell.lblFirstDetail,detailCell.lblSecondDetail,detailCell.lblThirdDetail].forEach({ $0?.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightSemibold)
                    $0?.textColor = R.color.salonX.fontDark()
                })
                
                detailCell.lblFirstDetail.text = "Type"
                detailCell.lblSecondDetail.text = "Appointments"
                detailCell.lblThirdDetail.text = "Price"
                return detailCell
            } else {
                [detailCell.lblFirstDetail,detailCell.lblSecondDetail,detailCell.lblThirdDetail].forEach({ $0?.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightRegular)
                })
            }
            
            if indexPath.row == 4 {
                detailCell.lblFirstDetail.textAlignment = .center
                [detailCell.lblFirstDetail,detailCell.lblSecondDetail,detailCell.lblThirdDetail].forEach({ $0?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightSemibold)
                    $0?.textColor = R.color.salonX.accent()
                })
                detailCell.lblFirstDetail.text = "Total"
                detailCell.lblSecondDetail.text = "10"
                detailCell.lblThirdDetail.text = "14000 Ron"
                return detailCell
            } else {
                [detailCell.lblFirstDetail,detailCell.lblSecondDetail,detailCell.lblThirdDetail].forEach({ $0?.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightRegular)
                })
            }
            return detailCell
            
        } else if tableView == tblTopServices {
            let detailCell = tblTopServices.dequeueReusableCell(withIdentifier: "detailCell") as! ReportDetailTableViewCell
            detailCell.selectionStyle = .none
            
            if indexPath.row == 0 {
                [detailCell.lblFirstDetail,detailCell.lblSecondDetail,detailCell.lblThirdDetail].forEach({ $0?.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightSemibold)
                    $0?.textColor = R.color.salonX.fontDark()
                })
                
                detailCell.lblFirstDetail.text = "Service"
                detailCell.lblSecondDetail.text = "Self-created"
                detailCell.lblThirdDetail.text = "SalonX"
                return detailCell
            } else {
                [detailCell.lblFirstDetail,detailCell.lblSecondDetail,detailCell.lblThirdDetail].forEach({ $0?.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightRegular)
                })
                detailCell.lblThirdDetail.textColor = R.color.salonX.accent()
                detailCell.lblSecondDetail.textColor = R.color.salonX.fontDark()
                detailCell.lblFirstDetail.text = "Service is Bla-Bla-Bla-Bla-Bla-Bla"
            }
            
            return detailCell
            
        } else if tableView == tblEmployees {
            
            let employeeDetailCell = tblEmployees.dequeueReusableCell(withIdentifier: "employeeCell") as! EmployeeReportDetailTableViewCell
            employeeDetailCell.selectionStyle = .none
            
            if indexPath.row == 0 {
                [employeeDetailCell.lblName, employeeDetailCell.lblSelfCreated, employeeDetailCell.lblSalonX, employeeDetailCell.lblLastMinute, employeeDetailCell.lblTotal].forEach( { $0?.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightSemibold)
                 $0?.textColor = R.color.salonX.fontDark()})
                employeeDetailCell.lblName.text = "Name"
                employeeDetailCell.lblSelfCreated.text = "Self-created"
                employeeDetailCell.lblLastMinute.text = "Last Minute"
                employeeDetailCell.lblSalonX.text = "SalonX"
                employeeDetailCell.lblTotal.text = "Total"
                return employeeDetailCell
                
            } else {
                [employeeDetailCell.lblName, employeeDetailCell.lblSelfCreated, employeeDetailCell.lblSalonX, employeeDetailCell.lblLastMinute, employeeDetailCell.lblTotal].forEach( {  $0?.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightRegular)
                })
                
                employeeDetailCell.lblTotal.textColor = R.color.salonX.accent()
                employeeDetailCell.lblName.text = employeeDetail[indexPath.row - 1]["name"] as? String
                employeeDetailCell.lblSelfCreated.text = employeeDetail[indexPath.row - 1]["self-created"] as? String
                employeeDetailCell.lblSalonX.text = employeeDetail[indexPath.row - 1]["salonx"] as? String
                employeeDetailCell.lblLastMinute.text = employeeDetail[indexPath.row - 1]["lastMinute"] as? String
                employeeDetailCell.lblTotal.text = employeeDetail[indexPath.row - 1]["total"] as? String
                
                return employeeDetailCell

            }
   
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblAppointment {
            if indexPath.row == 0 {
                return 40.0
            }
        } else if tableView == tblTopServices {
            if indexPath.row == 0 {
                 return 40.0
            }
        } else if tableView == tblEmployees {
            if indexPath.row == 0 {
                return 40.0
            }
        }
      return UITableViewAutomaticDimension
    }
}

extension ReportViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MonthStastisticCollectionViewCell
        
        cell.btnMonthName.setTitle(monthName[indexPath.row], for: .normal)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         print(monthName[indexPath.row])
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var calcutedSize = (monthName[indexPath.row] as NSString).size(attributes: nil)
        calcutedSize.width += 20
        return calcutedSize
    }

}
