//
//  DriverController.swift
//  PCL Admin
//
//  Created by Anish Verma on 12/27/18.
//  Copyright © 2018 Abihshek. All rights reserved.
//

import UIKit

class DriverController: UIViewController {
    @IBOutlet var addButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var fields: [UITextField]!
    var delegate:DriversController?
    
    var driverId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 8
        cancelButton.layer.cornerRadius = 8
        resetButton.layer.cornerRadius = 8
        for aField in fields
        {
            aField.layer.borderColor = UIColor.init(red: 128/255, green: 25/255, blue: 50/255, alpha: 1).cgColor
            aField.layer.borderWidth = 1
            aField.layer.cornerRadius = 8
        }
        // Do any additional setup after loading the view.
    }
    func setValuesForInputField(driver:Driver)  {
        let driverName:[String] = driver.DriverName.components(separatedBy: " ")
        fields[0].text = driverName[0]
        fields[1].text = driverName[1]
        fields[2].text = driver.PhoneNumber
        self.driverId = driver.DriverId
        addButton.setTitle("Update", for: .normal)
    }
    @IBAction func addButtonClicked(_ sender: Any) {
        let button:UIButton = sender as! UIButton
        if !isFieldsEmpty()
       {
        let jsonBody:Dictionary<String,Any>
        var urlStr:String!
        
        if button.titleLabel?.text == "Add" {
            jsonBody = [
                "FirstName": fields[0].text as Any,
                "LastName": fields[1].text as Any,
                "PhoneNumber": fields[2].text as Any
                           ]
            urlStr = baseURL + addDriver
        }
        else {
            jsonBody = [
                "DriverId": self.driverId as Any,
                "FirstName": fields[0].text as Any,
                "LastName": fields[1].text as Any,
                "PhoneNumber": fields[2].text!
                        ]
            urlStr = baseURL + updateDriver
        }
            RestManager.APIData(url: urlStr, httpMethod: RestManager.HttpMethod.post.self.rawValue, body: SerializedData(JSONObject: jsonBody)){Data,Error in
                if Error == nil {
                    do {
                        let resultData = try JSONDecoder().decode(RequestResult.self, from: Data as! Data)
                        self.displayAlertWith(message: resultData.Result)                        
                    } catch let JSONErr{
                        self.displayAlertWith(message: JSONErr.localizedDescription)
                    }
                }
            }
        }
    }
    func isFieldsEmpty() -> Bool{
        if fields[0].text!.isEmpty || fields[1].text!.isEmpty || fields[2].text!.isEmpty {
            let alert = Alert(message: "Please fill all the three fields.")
            self.present(alert, animated: true)
            return true
        }
        else{
            return false
        }
    }
    func displayAlertWith(message:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title:message, message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_ ) in
            self.dismiss(animated: true, completion: {self.cancelButtonClicked()}) }
            })
        }
    }
    @IBAction func cancelButtonClicked(){
        delegate?.refreshTable()
        self.dismiss(animated: true, completion: nil)
    }
}
