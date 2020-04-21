//
//  RouteForMaps.swift
//  PCL Admin
//
//  Created by Varun Nair on 4/20/20.
//  Copyright © 2020 Abihshek. All rights reserved.
//

import Foundation

struct RouteForMap: Decodable
{
    let RouteNo: Int?
    let RouteName: String?
    let DriverId: Int?
    let vehicleNo: String?
    var Customer: [Location]?
}

