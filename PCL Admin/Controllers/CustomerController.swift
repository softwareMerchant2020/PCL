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
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.layer.borderColor = UIColor.init(red: 128/255, green: 25/255, blue: 50/255, alpha: 1).cgColor
        timePicker.layer.borderWidth = 1
        timePicker.layer.cornerRadius = 8
        for aField in fields
        {
            aField.layer.borderColor = UIColor.init(red: 128/255, green: 25/255, blue: 50/255, alpha: 1).cgColor
            aField.layer.borderWidth = 1
            aField.layer.cornerRadius = 8
        }
        for aButton in buttons
        {
            aButton.layer.cornerRadius = 8
        }
    }
    
    @IBAction func cancelButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
}
