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
    
    func populateCell(_ route: [RouteDetail]) {
        self.routeNo.text = String(route[0].RouteNo)
        self.pickedUpBy.text = route[0].UpdatedByDriver
        let centerPt: CGPoint = statusContainer.center
        
        var x = 0
        var specimenCount = 0
        var lastPickUpTime: String = "-"
        
        for aLocation in route
        {
            specimenCount += Int(aLocation.NumberOfSpecimens)
            var imageName = ""
            switch CollectionStatus[aLocation.Status]
            {
                case "collected":
                    imageName = "greenDot.png"
                    lastPickUpTime = aLocation.PickUp_Time
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
                imageName = "redDot.png"
            }
            let imageView = UIImageView(image: UIImage(named: imageName)!)
            statusContainer.addSubview(imageView)
            imageView.frame = CGRect(x: (statusPixel+5)*x, y: 0, width: statusPixel, height: statusPixel)
            x+=1
        }
        
       
        let current = calculateRouteStatus(route: route)
        
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
    func getCustomer(customerId:Int,  completionHandler: @escaping (Location) -> ())  {
            RestManager.APIData(url: "https://pclwebapi.azurewebsites.net/api/Customer/GetCustomer" , httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil) { Data,Error in
                if Error==nil {
                    do {
                        let customerList = try JSONDecoder().decode([Location].self, from: Data as! Data)
                        for eachCustomer in customerList {
                            if eachCustomer.CustomerId == customerId {
                                completionHandler(eachCustomer)
                            }
                        }
                    } catch {
                        print("Error getting driver location")
                    }
                }
            }

        }
    func calculateRouteStatus(route:[RouteDetail]) -> RouteStatus {
        var i:[Int] = [Int]()
        var numberCompleted = 0
        var status:RouteStatus!
        
        for aLocation in route {
                if aLocation.Status == 0 {
                    numberCompleted = numberCompleted + 1
                    let result = comparePickUpTime(forCustomer: aLocation.CustomerId, recentPickupTime: aLocation.PickUp_Time)
                    i.append(result)
                }
            }
        if (numberCompleted == route.count) {
            status = RouteStatus.completed
        }
        else
        {
            for stat in i {
                if stat == 0 || stat == 1 {
                    status = RouteStatus.onTime
                }
                else {
                    status = RouteStatus.delaying
                }
            }
            
        }
        return RouteStatus.completed
        //return status
    }
    func comparePickUpTime(forCustomer CustomerId:Int, recentPickupTime:String) -> (Int) {
        var status = 0
        
           getCustomer(customerId: CustomerId) { (customer) in
               let dateFormatter = DateFormatter()
               dateFormatter.dateStyle = .none
               dateFormatter.dateFormat = "h:mm a"
            let dateObj = dateFormatter.date(from: customer.PickUpTime ?? "4:30 PM")
               let dateobj2 = dateFormatter.date(from: recentPickupTime)

               switch dateObj?.compare(dateobj2!)
               {
               case .orderedAscending:
                   print("picked earlier")
                status = 0
               case .orderedSame:
                   print("pickup on time")
                status = 1
               case .orderedDescending:
                   print("pickup delayed")
                status = 2
               default:
                   print("delayed")
                status = 2
               }
           }
        return status
       }
}
