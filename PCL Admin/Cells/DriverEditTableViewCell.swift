//
//  DriverEditTableViewCell.swift
//  PCL Admin
//
//  Created by Sangeetha Gengaram on 4/23/20.
//  Copyright © 2020 Abihshek. All rights reserved.
//

import UIKit

class DriverEditTableViewCell: UITableViewCell {
    @IBOutlet weak var driverName: UILabel!
    weak var viewController:DriversController?
    var driverObj:Driver!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func updateButtonClicked(_ sender: Any) {
       let presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DriverController") as! DriverController
        presentingController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        self.viewController?.present(presentingController, animated: true, completion: {
            presentingController.setValuesForInputField(driver: self.driverObj)
        })
       }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        let jsondata = [
            "DriverId": self.driverObj.DriverId,
            "DriverName": self.driverObj.DriverName,
            "PhoneNumber": self.driverObj.PhoneNumber as Any
            ] as [String : Any]
//        https://pclwebapi.azurewebsites.net/api/driver/DeleteDriver

        RestManager.APIData(url: "https://pclwebapi.azurewebsites.net/api/driver/DeleteDriver", httpMethod: RestManager.HttpMethod.post.self.rawValue, body: SerializedData(JSONObject: jsondata)) { (result, error) in
            if (error == nil) {
                do {
                    let resultdata = try JSONDecoder().decode(RequestResult.self, from: result as! Data)
                DispatchQueue.main.async {
                    let alert = UIAlertController(title:resultdata.Result, message: nil, preferredStyle: .alert)
                    self.viewController?.present(alert, animated: true, completion: {
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_ ) in
                        self.viewController?.dismiss(animated: true, completion: {
                            self.viewController?.loadData()
                        }) }
                    })
                }
                } catch {
                    print("Decode error:\(error.localizedDescription)")
                }
                
            }
        }
    
    }
    
    func setCellData(driver:Driver)  {
        self.driverObj = driver
        driverName.text = driver.DriverName
    }
}
