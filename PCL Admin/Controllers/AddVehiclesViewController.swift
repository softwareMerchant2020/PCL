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
    
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func addVehicleClicked(_ sender: Any) {
        var jsonBody = [
            "PlateNumber": fields[0].text,
          "Manufacturer": fields[1].text,
          "Model": fields[2].text
        ]
    }
}
