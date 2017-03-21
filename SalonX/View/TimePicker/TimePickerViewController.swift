//
//  TimePickerViewController.swift
//  SalonX
//
//  Created by DK on 24/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

enum ControlType: Int {
    case timePicker = 0
    case datePicker
}

class TimePickerViewController: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker?
    @IBOutlet weak var btnDone: UIButton?
    @IBOutlet weak var btnCancel: UIButton?
    
    @IBOutlet weak var viewWidth : NSLayoutConstraint!
    
    // MARK: - Properties
    let timeFormatter = DateFormatter()
    var time: String?
    var timePickerDelegate: TimePickerDelegate?
    var controlType: ControlType?
    var datePickerMode:UIDatePickerMode = .date
    
    // MARK: - Initialize view controller with nib.
    convenience init() {
        self.init(nibName: R.nib.timePickerView.name, bundle: nil)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations:  {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.30)
            self.view.transform = .identity
        }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations:  {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.30)
            self.view.transform = .identity
        }, completion: nil)
        
        if controlType == .timePicker {
            timePicker?.datePickerMode = .time
            timeFormatter.timeStyle = .short
            viewWidth.constant = 200.0
        } else if controlType == .datePicker {
            timePicker?.datePickerMode = datePickerMode
            timeFormatter.dateStyle = .long
            viewWidth.constant = 250.0
        }
    }
    
    //MARK: - Lifecycle of view
    override func viewDidLoad() {
        super.viewDidLoad()    
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = UIColor.clear
        }
    }
    
    
    // MARK: - Touch events
    @IBAction func btnDoneTapped() {
        time = timeFormatter.string(from: timePicker!.date)
        timePickerDelegate?.didSelectTime(time: time)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }


}
