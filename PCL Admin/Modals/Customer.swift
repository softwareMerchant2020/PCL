//
//  Customer.swift
//  PCL Admin
//
//  Created by Rutul Desai on 4/14/20.
//  Copyright © 2020 Abihshek. All rights reserved.
//

import Foundation

struct Customer: Decodable
{
    var CustomerId: Int
    var CustomerName: String?
    var StreetAddress: String?
    var City: String?
    var State: String?
    var Zip: Int?
}
