//
//  RouteDetail.swift
//  PCL Admin
//
//  Created by Rutul Desai on 4/20/20.
//  Copyright © 2020 Abihshek. All rights reserved.
//

import Foundation

struct RouteDetail: Decodable {
    var TranId:Int
    var RouteNo: Int
    var CustomerId:Int
    var Status:Int
    var PickUp_Dt: String
    var PickUp_Time: String?
    var NumberOfSpecimens: Int
    var CreatedDate: String
    var UpdatedByDriver: String
}
