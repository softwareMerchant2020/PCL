//
//  Location.swift
//  PCL Admin
//
//  Created by Anish Verma on 12/26/18.
//  Copyright © 2018 Abihshek. All rights reserved.
//

import Foundation

enum CollectionStatus: String {
    case notCollected = "NotCollected"
    case collected = "Collected"
    case rescheduled = "Rescheduled"
    case missed = "Missed"
    case closed = "Closed"
    case other = "Other"
}

struct Location{
    let labName: String
    let address: String
    let collectionStatus: CollectionStatus
    let specimenCount: String
    let pickedUpBy: String
    let pickUpTime: String
    let locationId: String
    var isSelected: Bool
}

extension Location {
    init?(_ location: [String: Any]) {
        self.labName = location["LabName"] as! String
        self.address = location["Address"] as! String
        self.collectionStatus = CollectionStatus(rawValue: location["CollectionStatus"] as! String)!
        self.specimenCount = location["SpecimenCollected"] as! String
        self.pickedUpBy = location["PickedUpBy"] as! String
        self.pickUpTime = location["PickUpTime"] as! String
        self.locationId = location["LocationId"] as! String
        self.isSelected = false
    }
}
