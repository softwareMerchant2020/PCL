//
//  distanceMatrixObj.swift
//  PCL Admin
//
//  Created by Varun Nair on 4/24/20.
//  Copyright © 2020 Abihshek. All rights reserved.
//

import Foundation

struct DistanceMatrixObj: Codable {
    var destination_addresses, origin_addresses: [String]?
    var rows: [Row]
    var status: String
}

// MARK: - Row
struct Row: Codable {
    var elements: [Element]
    
}

// MARK: - Element
struct Element: Codable {
    var distance, duration: Distance
    var status: String
}

// MARK: - Distance
struct Distance: Codable {
    var text: String
    var value: Int
}
