//
//  CustomerController.swift
//  PCL Admin
//
//  Created by Anish Verma on 12/27/18.
//  Copyright © 2018 Abihshek. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CustomerController: UIViewController {
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var fields: [UITextField]!
    @IBOutlet var timePicker: UIDatePicker!
    var isSelectingState:Bool = false
    var isEditMode:Bool = false
    var statePlist:Dictionary<String,Array<String>>?
    var stateList:[String] = []
    var selectedState:String?
    var stateTextField:UITextField!
    var zipTextField:UITextField!
    var strDate:String?
    var message:String?
    var location:CLLocation?
    var Customer:Location?
    var delegate:CustomersController?
    @IBOutlet weak var addCustomerLbl: UILabel!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isEditMode{
            self.fields[0].text = self.Customer?.CustomerName
            self.fields[0].allowsEditingTextAttributes = true
            self.fields[2].text = String(self.Customer?.Zip ?? 0)
            self.fields[2].allowsEditingTextAttributes = true
            self.fields[1].text = self.Customer?.StreetAddress
            self.fields[1].allowsEditingTextAttributes = true
            self.fields[3].text = self.Customer?.City
            self.fields[3].allowsEditingTextAttributes = true
            self.fields[4].text = self.Customer?.State
            self.fields[4].allowsEditingTextAttributes = true
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "hh:mm a"
            dateFormatter.dateStyle = .none
            let date = dateFormatter.date(from: self.Customer!.PickUpTime ?? "" )
            self.timePicker.setDate(date ?? Date(), animated: true)
            self.buttons[2].setTitle("Update", for: .normal)
            self.addCustomerLbl.text = "Update Customer"
        }
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        self.strDate = dateFormatter.string(from: sender.date)
    }
    @IBAction func cancelButtonClicked(){
        self.delegate?.refreshTable()
        self.dismiss(animated: true, completion: nil)
    }
        
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void )
    {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString){ (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    self.location = placemark.location!
                    completionHandler(self.location?.coordinate ?? CLLocationCoordinate2D(), nil)
                    return
                }
            }
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        if self.isEditMode{
            if fields[0].text == "" || fields[1].text == "" || fields[2].text == "" || fields[3].text == "" || fields[4].text == ""{
                self.message = "Please fill up all details!"
                let alert = UIAlertController(title: self.message, message: nil, preferredStyle: .alert)
                self.present(alert,animated: true)
            } else {
                let Seperator: String = ", "
                     let addressToGeocode: String = (fields[1].text! + Seperator + fields[3].text! + Seperator + fields[4].text! + Seperator + fields[2].text!)
                     
                     getCoordinate(addressString: addressToGeocode){
                         (CLLocationCoordinate2D, String) in
                         let jsonBody = [
                            "CustomerId": self.Customer?.CustomerId ?? 0,
                             "CustomerName": self.fields[0].text!,
                             "StreetAddress": self.fields[1].text!,
                             "City": self.fields[3].text!,
                             "State": self.fields[4].text!,
                             "Zip": Int(self.fields[2].text!)!,
                             "PickupTime": self.strDate ?? self.Customer?.PickUpTime ?? "",
                             "Cust_Lat": CLLocationCoordinate2D.latitude,
                             "Cust_Log": CLLocationCoordinate2D.longitude
                             ] as [String : Any]
                         RestManager.APIData(url: baseURL + updateCustomer, httpMethod: RestManager.HttpMethod.post.self.rawValue, body: SerializedData(JSONObject: jsonBody)){Data,Error in
                             if Error == nil {
                                 do {
                                     let resultData = try JSONDecoder().decode(RequestResult.self, from: Data as! Data)
                                     
                                     if resultData.Result == "success"{
                                         self.message = "Customer Updated"
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
        } else {
            if fields[0].text == "" || fields[1].text == "" || fields[2].text == "" || fields[3].text == "" || fields[4].text == ""{
                 self.message = "Please fill up all details!"
                 let alert = UIAlertController(title: self.message, message: nil, preferredStyle: .alert)
                 self.present(alert,animated: true)
             } else {
                 let Seperator: String = ", "
                 let addressToGeocode: String = (fields[1].text! + Seperator + fields[3].text! + Seperator + fields[4].text! + Seperator + fields[2].text!)
                 
                 getCoordinate(addressString: addressToGeocode){
                     (CLLocationCoordinate2D, String) in
                     let jsonBody = [
                         "CustomerName": self.fields[0].text!,
                         "StreetAddress": self.fields[1].text!,
                         "City": self.fields[3].text!,
                         "State": self.fields[4].text!,
                         "Zip": Int(self.fields[2].text!)!,
                         "PickupTime": self.strDate!,
                         "Cust_Lat": CLLocationCoordinate2D.latitude,
                         "Cust_Log": CLLocationCoordinate2D.longitude
                         ] as [String : Any]
                     RestManager.APIData(url: baseURL + addCustomerURL, httpMethod: RestManager.HttpMethod.post.self.rawValue, body: SerializedData(JSONObject: jsonBody)){Data,Error in
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
