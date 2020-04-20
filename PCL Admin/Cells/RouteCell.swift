//
//  RouteCell.swift
//  PCL Admin
//
//  Created by Anish Verma on 12/27/18.
//  Copyright © 2018 Abihshek. All rights reserved.
//

import UIKit

enum RouteStatus {
    case onTime
    case delaying
    case completed
}

class RouteCell: UITableViewCell {
    let statusPixel = 17
    @IBOutlet var routeNo: UILabel!
    @IBOutlet var statusContainer: UIView!
    @IBOutlet var pickedUpAt: UILabel!
    @IBOutlet var pickedUpBy: UILabel!
    @IBOutlet var specimenCount: UILabel!
    @IBOutlet var vehicleStatus: UILabel!
    @IBOutlet var locationStatus: UILabel!
    
    func populateCell(_ route: GetRoute) {
        self.routeNo.text = String(route.Route.RouteNo)
        self.pickedUpBy.text = String(route.Route.DriverId)
        let centerPt: CGPoint = statusContainer.center
        
        var x = 0
        var specimenCount = 0
        var lastPickUpTime: String = "-"
        
//        for aLocation in route.locations
//        {
//            specimenCount += Int(aLocation.specimenCount)!
//            var imageName = ""
//            switch aLocation.collectionStatus
//            {
//                case .collected:
//                    imageName = "greenDot.png"
//                    lastPickUpTime = aLocation.pickUpTime
//                case .notCollected:
//                    imageName = "greyDot.png"
//                case .rescheduled:
//                    imageName = "blueDot.png"
//                case .missed:
//                    imageName = "yellowDot.png"
//                case .closed:
//                    imageName = "closedDot.png"
//                case .other:
//                    imageName = "redDot.png"
//            }
//            let imageView = UIImageView(image: UIImage(named: imageName)!)
//            statusContainer.addSubview(imageView)
//            imageView.frame = CGRect(x: (statusPixel+5)*x, y: 0, width: statusPixel, height: statusPixel)
//            x+=1
//        }
        
        let routeStatus: [RouteStatus] = [RouteStatus.completed,
                                          RouteStatus.delaying,
                                          RouteStatus.onTime,]
        let current = routeStatus[Int.random(in: 0..<routeStatus.count)]
        
        switch current {
        case .delaying:
            vehicleStatus.textColor = UIColor.init(red: 204/255, green: 0/255, blue: 0/255, alpha: 1)
            vehicleStatus.text = "Delaying"
        case .onTime:
            vehicleStatus.textColor = UIColor.init(red: 0/255, green: 120/255, blue: 0/255, alpha: 1)
            vehicleStatus.text = "On Time"
        case .completed:
            vehicleStatus.textColor = UIColor.init(red: 0/255, green: 153/255, blue: 0/255, alpha: 1)
            vehicleStatus.text = "Completed"
        }
        
        self.pickedUpAt.text = lastPickUpTime
        self.specimenCount.text = String(specimenCount)
        //statusContainer.frame=CGRect(x: statusContainer.frame.origin.x, y: statusContainer.frame.origin.y, width: CGFloat((statusPixel+5)*route.locations.count-10), height: statusContainer.frame.size.height)
        statusContainer.center = centerPt
    }
}
