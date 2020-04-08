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
    
    @IBAction func cancelButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
}
