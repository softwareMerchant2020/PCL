//
//  EditRouteCell.swift
//  PCL Admin
//
//  Created by Anish Verma on 1/2/19.
//  Copyright © 2019 Abihshek. All rights reserved.
//

import UIKit

class EditRouteCell: UITableViewCell {
    @IBOutlet var routeNo: UILabel!
    @IBOutlet var routeName: UILabel!
    @IBOutlet var driver: UILabel!
    @IBOutlet var vehicle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populateCell(_ route: Route) {
        self.routeNo.text = String(route.RouteNo)
        self.routeName.text = route.RouteName
        self.driver.text = String(route.DriverId)
        self.vehicle.text = route.VehicleNo
    }
}
