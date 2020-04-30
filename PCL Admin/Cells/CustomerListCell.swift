//
//  CustomerListCell.swift
//  PCL Admin
//
//  Created by Rutul Desai on 4/21/20.
//  Copyright © 2020 Abihshek. All rights reserved.
//

import UIKit

class CustomerListCell: UITableViewCell {
    @IBOutlet weak var PickUpTimeLbl: UILabel!
    @IBOutlet weak var CollectionStatusImage: UIImageView!
    
    @IBOutlet weak var CustomerIDLbl: UILabel!
    @IBOutlet weak var CollectionStatusLbl: UILabel!
    @IBOutlet weak var SpecimensDistanceLbl: UILabel!
    @IBOutlet weak var AddressLbl: UILabel!
    @IBOutlet weak var CustomerNameLbl: UILabel!
    var distanceMatrix = DistanceMatrixAPI()
    var distance = String()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func populateCell(_ location: Location, distance:String) {
        
        let driverArr = driverLocForDistanceMatrix(xcoord: UserDefaults.standard.double(forKey: "xCoord"),ycoord: UserDefaults.standard.double(forKey: "yCoord"))
        let customerArr = driverLocForDistanceMatrix(xcoord: location.Cust_Lat ?? 0, ycoord: location.Cust_Log ?? 0)
        let urlString = distanceMatrix.URLGenForDistanceMatrixAPI(startPoint: driverArr, endPoint: customerArr)
        distanceMatrix.distanceMatrixAPICall(URLForUse: urlString){distanceMatrixReturn,error in
            
            DispatchQueue.main.async {
                if error == nil && distanceMatrixReturn?.rows[0].elements[0].distance.text != "" {
                    if let distance = distanceMatrixReturn?.rows[0].elements[0].distance.text {
                        self.SpecimensDistanceLbl.text = distance + "es away"
                    } else if location.CollectionStatus == "Collected" {
                        self.SpecimensDistanceLbl.text = ("Specimen collected: " + String(location.SpecimensCollected ?? 0))
                        
                    }
                    self.CustomerNameLbl.text = location.CustomerName
                    let address = location.StreetAddress
                    self.AddressLbl.text = address
                    self.CustomerIDLbl.text = String(location.CustomerId)
                    self.CustomerNameLbl.text = String(location.CustomerName!)
                    var str = location.PickUpTime
                    for _ in 0...10{
                        str?.removeFirst()
                    }
                    self.PickUpTimeLbl.text = String(str!)
                    if location.CollectionStatus == "NotCollected"{
                        self.CollectionStatusLbl.text = "In-Process"
                        self.CollectionStatusImage.isHidden = true
                        self.CollectionStatusLbl.adjustsFontSizeToFitWidth = true
                    } else if location.CollectionStatus == "Collected"{
                        self.CollectionStatusLbl.text = location.CollectionStatus
                        self.CollectionStatusImage.isHidden = false
                    } else {
                        self.CollectionStatusLbl.text = location.CollectionStatus
                        self.CollectionStatusImage.isHidden = true
                        self.CollectionStatusLbl.adjustsFontSizeToFitWidth = true
                    }
                }
            }
        }
        
    }
    func driverLocForDistanceMatrix(xcoord:Double,ycoord:Double)->[Double]
    {
        var driverLocArray = [Double]()
        driverLocArray.append(xcoord)
        driverLocArray.append(ycoord)
        return driverLocArray
    }
    
    
}
