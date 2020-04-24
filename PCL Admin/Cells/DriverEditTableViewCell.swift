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
    
    func setCellData(driver:Driver)  {
        self.driverObj = driver
        driverName.text = driver.DriverName
    }
}
