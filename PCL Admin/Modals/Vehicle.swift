//
//  Vehicle.swift
//  PCL Admin
//
//  Created by Rutul Desai on 4/13/20.
//  Copyright © 2020 Abihshek. All rights reserved.
//

import Foundation

struct Vehicle: Decodable {
    var VehicleId:Int
    var PlateNumber: String
    var Manufacturer: String
    var Model: String
}
