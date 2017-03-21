//
//  DKDropDownView.swift
//  Masakin
//
//  Created by DK on 14/11/16.
//
//

import UIKit

extension UITextField {
    func setDropDown(delegate:DropDowndelegate? , array : NSMutableArray) {
        
        if array.count > 0{
            let dropDownView = Bundle.main.loadNibNamed("DKDropDownView", owner: nil, options: nil)?[0] as! DKDropDownView
            dropDownView.delegate = delegate
            dropDownView.inputArray = array
            dropDownView.textfield = self
            self.tintColor = UIColor.clear
            self.inputView = dropDownView
            
        }
        else{
            self.resignFirstResponder()
        }
      
    }
}

@objc protocol DropDowndelegate {
   @objc optional func textFieldDidPressDone(textField:UITextField,index:Int)
   @objc optional func textFieldDidPressCancle(textField:UITextField)
}

class DKDropDownView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet var pickerView: UIPickerView!
    var delegate:DropDowndelegate?
    public var inputArray:NSMutableArray!
    public var textfield:UITextField!
    private var selectedValue:String = ""

    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var btnCancel: UIBarButtonItem!
    @IBOutlet var btnDone: UIBarButtonItem!
    @IBOutlet var vwArabic: UIView!
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pickerView.delegate = self
            btn1.setTitle("Cancel", for: UIControlState.normal)
            btn2.setTitle("Done", for: UIControlState.normal)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
      
        return inputArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
       
        return inputArray.object(at: row) as? String
       
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedValue = (inputArray.object(at: row) as? String)!
        
    }
   
   
    @IBAction func btnDoneAction(_ sender: Any) {
        textfield.resignFirstResponder()
        let selectedIndex:Int = self.pickerView.selectedRow(inComponent: 0)
        selectedValue = (self.inputArray.object(at: selectedIndex) as? String)!
    }
    
    @IBAction func btnCancleAction(_ sender: Any) {
        textfield.resignFirstResponder()
        if delegate != nil {
            self.delegate?.textFieldDidPressCancle!(textField: textfield)
        }
    }
}
