//
//  CustomerController.swift
//  PCL Admin
//
//  Created by Anish Verma on 12/27/18.
//  Copyright © 2018 Abihshek. All rights reserved.
//

import UIKit

class CustomerController: UIViewController {
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var fields: [UITextField]!
    @IBOutlet var timePicker: UIDatePicker!
    var isSelectingState:Bool = false
    var statePlist:Dictionary<String,Array<String>>?
    var stateList:[String] = []
    var selectedState:String?
    var stateTextField:UITextField!
    var zipTextField:UITextField!
    var strDate:String?
    var message:String?
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = Bundle.main.url(forResource: "statedictionary", withExtension: "plist")!
           let stateData = try! Data(contentsOf: url)
        statePlist = try! PropertyListSerialization.propertyList(from: stateData, options: [], format: nil) as! Dictionary<String,Array<String>>
        if ((statePlist?.keys) != nil)
        {
            stateList.append(contentsOf: statePlist!.keys)
        }
        stateList = stateList.sorted()

        timePicker.layer.borderColor = UIColor.init(red: 128/255, green: 25/255, blue: 50/255, alpha: 1).cgColor
        timePicker.layer.borderWidth = 1
        timePicker.layer.cornerRadius = 8
        for aField in fields
        {
            aField.delegate = self
            aField.layer.borderColor = UIColor.init(red: 128/255, green: 25/255, blue: 50/255, alpha: 1).cgColor
            aField.layer.borderWidth = 1
            aField.layer.cornerRadius = 8
            if aField.tag == 3 {
                stateTextField = aField
            }
            else if aField.tag == 4
            {
                zipTextField = aField
            }
        }
        for aButton in buttons
        {
            aButton.layer.cornerRadius = 8
        }
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        self.strDate = dateFormatter.string(from: sender.date)
    }
    @IBAction func cancelButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        
        
        if fields[0].text == "" || fields[1].text == "" || fields[2].text == "" || fields[3].text == "" || fields[4].text == ""{
            
        } else {
            let jsonBody = [
                "CustomerName": fields[0].text,
                "City": fields[3].text,
                "StreetAddress": fields[1].text,
                "State":fields[4].text,
                "Zip":fields[2].text,
                "PickUpTime":strDate
            ]
            
            RestManager.APIData(url: baseURL + addCustomer, httpMethod: RestManager.HttpMethod.post.self.rawValue, body: SerializedData(JSONObject: jsonBody)){Data,Error in
                if Error == nil {
                    do {
                        let resultData = try JSONDecoder().decode(RequestResult.self, from: Data as! Data)
                        
                        if resultData.Result == "success"{
                            self.message = "Customer Added"
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: self.message, message: nil, preferredStyle: .alert)
                                 self.present(alert, animated: true, completion: {
                                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_ ) in
                                        self.dismiss(animated: true, completion: {self.cancelButtonClicked()}) }
                                })
                            }
                        } else {
                            self.message = resultData.Result
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: self.message, message: nil, preferredStyle: .alert)
                                 self.present(alert, animated: true, completion: {
                                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_ ) in
                                        self.dismiss(animated: true, completion: {self.cancelButtonClicked()}) }
                                })
                            }
                        }

                    } catch let JSONErr{
                        self.message = JSONErr.localizedDescription
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: self.message, message: nil, preferredStyle: .alert)
                             self.present(alert, animated: true, completion: {
                                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_ ) in
                                    self.dismiss(animated: true, completion: {self.cancelButtonClicked()}) }
                            })
                        }
                    }
                }
            }
       }
    }
    func createPickerView(field:UITextField) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        field.inputView = pickerView
        dismissPickerView(field: field)
    }
    func dismissPickerView(field:UITextField) {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       field.inputAccessoryView = toolBar
    }
    @objc func action() {
          view.endEditing(true)
    }
    
}
extension CustomerController:UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isSelectingState {
            return stateList.count
        }
        else {
            return statePlist?[selectedState ?? ""]?.count ?? 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isSelectingState {
            return stateList[row]
        }
        else {
            return statePlist?[selectedState ?? ""]?[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isSelectingState {
            stateTextField.text = stateList[row]
            selectedState = stateList[row]
        }
        else
        {
            zipTextField.text = statePlist?[selectedState ?? ""]?[row]
        }
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 3  {
            isSelectingState = true
            self.createPickerView(field: textField)
        }
        else if textField.tag == 4
        {
            isSelectingState = false
            self.createPickerView(field: textField)
        }
    }
   
    
}
