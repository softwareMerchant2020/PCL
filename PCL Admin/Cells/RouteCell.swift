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
    
    func populateCell(_ route: [RouteDetail], drivers:[Driver]?, routeData:GetRoute?, driversLocs:Dictionary<Int, DriverLocation>?) {
        self.routeNo.text = String(route[0].RouteNo)
        let driverName = drivers?.first(where:  {$0.DriverId == Int(route[0].UpdatedByDriver)})?.DriverName
        self.pickedUpBy.text = driverName
        let centerPt: CGPoint = statusContainer.center
        
        var x = 0
        var specimenCount = 0
        var lastPickUpTime: String = "-"
        
        if let customers = routeData?.Customer{
            var imageName = ""
            for customer in customers{
                let currentRouteCustomer = route.first(where:{$0.CustomerId == customer.CustomerId})
                if let currentRoute = currentRouteCustomer{
                    var str = currentRoute.PickUp_Time
                    for _ in 0...10{
                        str?.removeFirst()
                    }
                    switch CollectionStatus[currentRoute.Status]
                    {
                    case "collected":
                        imageName = "greenDot.png"
                        lastPickUpTime = str ?? ""
                    case "notCollected":
                        imageName = "greyDot.png"
                    case "rescheduled":
                        imageName = "blueDot.png"
                    case "missed":
                        imageName = "yellowDot.png"
                    case "closed":
                        imageName = "closedDot.png"
                    case "other":
                        imageName = "redDot.png"
                    default:
                        imageName = "greyDot.png"
                    }
                } else {
                    imageName = "greyDot.png"
                }
                let imageView = UIImageView(image: UIImage(named: imageName)!)
                statusContainer.addSubview(imageView)
                imageView.frame = CGRect(x: (statusPixel+5)*x, y: 0, width: statusPixel, height: statusPixel)
                x+=1
            }
        }
        for aLocation in route
        {
            specimenCount += Int(aLocation.NumberOfSpecimens)
        }
        if let customers = routeData?.Customer {
           calculateRouteStatus(route: route, allCustomers: customers, driverLocation: driversLocs?[Int(route[0].UpdatedByDriver)!]) { (current) in
            DispatchQueue.main.async {
                switch current {
                case .delaying:
                    self.vehicleStatus.textColor = UIColor.init(red: 204/255, green: 0/255, blue: 0/255, alpha: 1)
                    self.vehicleStatus.text = "Delaying"
                case .onTime:
                    self.vehicleStatus.textColor = UIColor.init(red: 0/255, green: 120/255, blue: 0/255, alpha: 1)
                    self.vehicleStatus.text = "On Time"
                case .completed:
                    self.vehicleStatus.textColor = UIColor.init(red: 0/255, green: 153/255, blue: 0/255, alpha: 1)
                    self.vehicleStatus.text = "Completed"
                }
            }
            }
        }
        self.pickedUpAt.text = lastPickUpTime
        self.specimenCount.text = String(specimenCount)
        //statusContainer.frame=CGRect(x: statusContainer.frame.origin.x, y: statusContainer.frame.origin.y, width: CGFloat((statusPixel+5)*route.locations.count-10), height: statusContainer.frame.size.height)
        statusContainer.center = centerPt
    }

    func calculateRouteStatus(route:[RouteDetail], allCustomers:[Location], driverLocation:DriverLocation?,  completionHandler:@escaping (RouteStatus) -> ()) {
        if driverLocation == nil {
            return
        }
        var numberCompleted = 0
        var status:RouteStatus = RouteStatus.onTime
        
        for aLocation in route {
            if (aLocation.Status == 1) {
                numberCompleted = numberCompleted + 1
            }
        }
        var index = 0
        
        for aCustomer in allCustomers {
            if aCustomer.CollectionStatus == "Not Collected" {
                break
            }
            else {
                index = index + 1
                continue
            }
        }
        if (numberCompleted == allCustomers.count) {
            completionHandler(RouteStatus.completed)
        }
        else
        {
            if index < allCustomers.count {
                let cust = allCustomers[index]
                if !(cust.Cust_Lat == 0.0) {
                    calculateETA(custLoc: cust, driverLoc: driverLocation!) { (timeInSeconds) in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .none
                    dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    
                        let dateObj = dateFormatter.date(from: cust.PickUpTime!)
                    let nowDate:String = dateFormatter.string(from: Date())
                    var latestDateObj = dateFormatter.date(from: nowDate)
                    latestDateObj = latestDateObj?.addingTimeInterval(TimeInterval(timeInSeconds))
                    switch latestDateObj?.compare(dateObj ?? Date())
                    {
                        case .orderedAscending:
                            status = RouteStatus.onTime
                        case .orderedSame:
                            status = RouteStatus.onTime
                        case .orderedDescending:
                            status = RouteStatus.delaying
                        case .none:
                            status  = RouteStatus.onTime
                        }
                     completionHandler(status)
                    }
                }
            }
        }
    }
    func calculateETA(custLoc:Location, driverLoc:DriverLocation, completionHandler:@escaping (Int) -> ()) {
        let distanceMatrix = DistanceMatrixAPI()

        let customerArr = driverLocForDistanceMatrix(xcoord: custLoc.Cust_Lat ?? 0, ycoord: custLoc.Cust_Log ?? 0)
        let driverArr = driverLocForDistanceMatrix(xcoord: driverLoc.Lat ?? 0, ycoord: driverLoc.Log ?? 0)
        let urlString = distanceMatrix.URLGenForDistanceMatrixAPI(startPoint: driverArr, endPoint: customerArr)
        distanceMatrix.distanceMatrixAPICall(URLForUse: urlString) { (distanceMatObject, error) in
            if (distanceMatObject != nil && distanceMatObject?.rows[0].elements[0].duration.value != 0) {
                    completionHandler((distanceMatObject?.rows[0].elements[0].duration.value)!)
                    }
        }
    }
}
