//
//  Route.swift
//  PCL Admin
//
//  Created by Anish Verma on 12/26/18.
//  Copyright © 2018 Abihshek. All rights reserved.
//

import Foundation

struct Route: Decodable {
    let RouteNo: Int
    let RouteName: String
    let DriverId: Int
    let vehicleNo: String
    var Location: [Location]
}

extension Route {
        init?(_ route: [String: Any]) {
        guard let routeNo = route["Route No."] as? String,
        let assignee = route["Asignee"] as? String, let locations = route["Locations"] as? Array<[String:Any]> else {
                return nil
        }
        self.routeName = route["Route Name"] as! String
        self.vehicleNo = route["Vehicle No."] as! String
        self.routeNo = routeNo
        self.assignee = assignee
        self.locations = []
        for aLocation in locations
        {
            self.locations.append(Location(aLocation)!)
        }
    }
}
