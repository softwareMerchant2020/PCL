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
    var delegate:VehiclesController?
    var isUpdating:Bool = false
    var vehicleId:Int?
    
    
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
        for aField in fields {
            aField.text = ""
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        delegate?.refreshTable()
        self.dismiss(animated: true, completion: nil)
    }
   
    func updateVehicleInfo(vehicle:Vehicle)  {
        fields[0].text = vehicle.PlateNumber
        fields[1].text = vehicle.Manufacturer
        fields[2].text = vehicle.Model
        vehicleId = vehicle.VehicleId
        addButton.setTitle("Update", for: .normal)
        isUpdating = true
    }
    @IBAction func addVehicleClicked(_ sender: Any) {
        let jsonBody:Dictionary<String,Any>!
        if fields[0].text == "" || fields[1].text == "" || fields[2].text == ""{
            let alert = Alert(message: "Please fill all the three fields.")
            self.present(alert, animated: true)
        } else {
            let urlStr:String?
            if !isUpdating {
                jsonBody = [
                    "PlateNumber": fields[0].text as Any,
                    "Manufacturer": fields[1].text as Any,
                    "Model": fields[2].text as Any
                ]
                urlStr = baseURL + addVehicleAPI
            }
            else {
               jsonBody = [
                "VehicleId" : self.vehicleId as Any,
                "PlateNumber": fields[0].text as Any,
                  "Manufacturer": fields[1].text as Any,
                  "Model": fields[2].text as Any
                ]
                urlStr = baseURL + updateVehicleAPI
            }
            RestManager.APIData(url: urlStr!, httpMethod: RestManager.HttpMethod.post.self.rawValue, body: SerializedData(JSONObject: jsonBody as Any)){Data,Error in
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
    func displayAlertWith(message:String)  {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
             self.present(alert, animated: true, completion: {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_ ) in
                    self.dismiss(animated: true, completion: {self.cancelButtonClicked(self)}) }
            })
        }
    }
}
