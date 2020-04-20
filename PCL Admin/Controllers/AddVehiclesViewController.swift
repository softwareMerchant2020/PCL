//
//  AddVehiclesViewController.swift
//  PCL Admin
//
//  Created by Sangeetha Gengaram on 4/14/20.
//  Copyright © 2020 Abihshek. All rights reserved.
//

import UIKit

class AddVehiclesViewController: UIViewController {

   
    @IBOutlet var fields: [UITextField]!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    var message = ""
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

    }
    
    @IBAction func resetButtonClicked(_ sender: Any) {
    }
    
    
    @IBAction func cancelButtonClicked() {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func addVehicleClicked(_ sender: Any) {
        let jsonBody = [
            "PlateNumber": fields[0].text,
          "Manufacturer": fields[1].text,
          "Model": fields[2].text
        ]
        if fields[0].text == "" || fields[1].text == "" || fields[2].text == ""{
            let alert = Alert(message: "Please fill all the three fields.")
            self.present(alert, animated: true)
        } else {
            RestManager.APIData(url: baseURL + addVehicle, httpMethod: RestManager.HttpMethod.post.self.rawValue, body: SerializedData(JSONObject: jsonBody)){Data,Error in
                if Error == nil {
                    do {
                        let resultData = try JSONDecoder().decode(RequestResult.self, from: Data as! Data)
                        if resultData.Result == "success"{
                            self.message = "Vehicle Added"
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
