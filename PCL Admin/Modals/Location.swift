//
//  Location.swift
//  PCL Admin
//
//  Created by Anish Verma on 12/26/18.
//  Copyright © 2018 Abihshek. All rights reserved.
//

import Foundation

//enum CollectionStatus: String, Decodable {
//    case notCollected = "NotCollected"
//    case collected = "Collected"
//    case rescheduled = "Rescheduled"
//    case missed = "Missed"
//    case closed = "Closed"
//    case other = "Other"
//}
    
struct Location: Decodable{
    var CustomerName: String?
    var StreetAddress: String?
    var State: String?
    var Zip: String?
    var City: String?
    var CollectionStatus: String?
    var SpecimensCollected: Int?
    var PickUpTime: String?
    var CustomerId: Int
    var IsSelected: Bool
    var Cust_Lat: Double?
    var Cust_Log: Double?
}

//extension Location {
//    init?(_ location: [String: Any]) {
//        self.CustomerName = location["LabName"] as! String
//        self.address = location["Address"] as! String
//        self.collectionStatus = CollectionStatus(rawValue: location["CollectionStatus"] as! String)!
//        self.specimenCount = location["SpecimenCollected"] as! String
//        self.pickedUpBy = location["PickedUpBy"] as! String
//        self.pickUpTime = location["PickUpTime"] as! String
//        self.locationId = location["LocationId"] as! String
//        self.isSelected = false
//    }
//}
