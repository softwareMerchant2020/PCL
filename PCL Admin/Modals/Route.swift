//
//  Route.swift
//  PCL Admin
//
//  Created by Anish Verma on 12/26/18.
//  Copyright © 2018 Abihshek. All rights reserved.
//

import Foundation

struct Route: Decodable {
    var RouteNo: Int
    var RouteName: String
    var DriverId: Int
    var VehicleNo: String
}

extension Route {
        init?(_ route: [String: Any]) {
        guard let routeNo = route["Route No."] as? Int,
        let assignee = route["Asignee"] as? Int, let locations = route["Locations"] as? Array<[String:Any]> else {
                return nil
        }
        self.RouteName = route["Route Name"] as! String
        self.VehicleNo = route["Vehicle No."] as! String
        self.RouteNo = routeNo
        self.DriverId = assignee
        //self.locations = []
//        for aLocation in locations
//        {
//            self.locations.append(Location(aLocation)!)
//        }
    }
}
