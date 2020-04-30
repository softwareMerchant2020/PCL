//
//  GetRoute.swift
//  PCL Admin
//
//  Created by Rutul Desai on 4/17/20.
//  Copyright © 2020 Abihshek. All rights reserved.
//

import Foundation

struct GetRoute: Decodable {
    var Route:Route
    var Customer:[Location]
}
