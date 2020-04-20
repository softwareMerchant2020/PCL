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
    var message:String?
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
    
    @IBAction func addButtonClicked(_ sender: Any) {
        if fields[0].text == "" || fields[1].text == "" || fields[2].text == ""{
            let alert = Alert(message: "Please fill all the three fields.")
            self.present(alert, animated: true)
        } else {
            let jsonBody = [
                "FirstName": fields[0].text,
            "LastName": fields[1].text,
            "PhoneNumber": fields[2].text
            ]
            RestManager.APIData(url: baseURL + addDriver, httpMethod: RestManager.HttpMethod.post.self.rawValue, body: SerializedData(JSONObject: jsonBody)){Data,Error in
                if Error == nil {
                    do {
                        let resultData = try JSONDecoder().decode(RequestResult.self, from: Data as! Data)
                        if resultData.Result == "success"{
                            self.message = "Driver Added"
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
    @IBAction func cancelButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
}
