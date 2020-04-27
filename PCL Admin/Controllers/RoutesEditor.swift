//
//  RoutesEditor.swift
//  PCL Admin
//
//  Created by Anish Verma on 12/27/18.
//  Copyright © 2018 Abihshek. All rights reserved.
//

import UIKit

class RoutesEditor: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var driverButton: UIButton!
    @IBOutlet var locationsTable: UITableView!
    @IBOutlet var routeName: UITextField!
    @IBOutlet weak var RouteNumberLbl: UILabel!
    @IBOutlet var vehicleButton: UIButton!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    var myRoute: Route?
    var driverName: String?
    var myLocation: [Location]?
    var message:String?
    var isEditMode:Bool = false
    @IBOutlet weak var addNewRouteLbl: UILabel!
    
    @IBOutlet weak var buttonStackView: UIStackView!
    var selectedDriver: String = "   ---   "
    var selectedDriverID:Int?
    var selectedVehicle: String = "   ---   "
    var routeLocations = [Location]()
    var routeNumberModel:RouteNumber?
    var routeNumber:Int?
    var existingRouteController:ExistingRoutesController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        driverButton.layer.borderWidth = 1
        driverButton.layer.borderColor = UIColor.init(red: 128/255, green: 25/255, blue: 50/255, alpha: 1).cgColor
        driverButton.layer.cornerRadius = 8
        locationsTable.layer.borderWidth = 1
        locationsTable.layer.borderColor = UIColor.init(red: 128/255, green: 25/255, blue: 50/255, alpha: 1).cgColor
        locationsTable.layer.cornerRadius = 8
        routeName.layer.borderWidth = 1
        routeName.layer.borderColor = UIColor.init(red: 128/255, green: 25/255, blue: 50/255, alpha: 1).cgColor
        routeName.layer.cornerRadius = 8
        vehicleButton.layer.borderWidth = 1
        vehicleButton.layer.borderColor = UIColor.init(red: 128/255, green: 25/255, blue: 50/255, alpha: 1).cgColor
        vehicleButton.layer.cornerRadius = 8
        addButton.layer.cornerRadius = 8
        cancelButton.layer.cornerRadius = 8
        
        RestManager.APIData(url: baseURL + getLatestRouteNumber, httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){
            (Data, Error) in
            if Error == nil{
                do {
                    self.routeNumberModel = try JSONDecoder().decode(RouteNumber.self, from: Data as! Data )
                    DispatchQueue.main.async {
                        if self.isEditMode{
                            self.RouteNumberLbl.text = "Route No.: " + String(self.routeNumber ?? 0)
                        } else {
                            self.RouteNumberLbl.text = "Route No.: " + String(self.routeNumberModel?.RouteNo ?? 0)
                        }
                    }
                } catch let JSONErr{
                    print(JSONErr.localizedDescription)
                }
            }
        }
        
        
        if let aRoute = myRoute {
            self.routeNumber = aRoute.RouteNo
            self.routeName.text = aRoute.RouteName
            self.selectedDriver = driverName ?? "" 
            self.selectedVehicle = aRoute.VehicleNo ?? ""
            self.routeLocations = myLocation!
        }
        if isEditMode{
            self.addButton.setTitle("Update", for: .normal)
            self.addNewRouteLbl.text = "Update Route"
        }
        
        refreshDriver()
        refreshVehicle()
    }
    
    @IBAction func driverButtonTapped(_ sender: UIButton){
        let presentingController: DriversController
        presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DriversController") as! DriversController
        presentingController.delegate = self
        presentingController.isEditMode = false
        presentingController.isAvailable = true
        presentingController.modalPresentationStyle = UIModalPresentationStyle.popover
        present(presentingController, animated: true, completion: nil)
        
        presentingController.preferredContentSize = CGSize(width: 400, height: 400)
        
        let popoverPresentationController = presentingController.popoverPresentationController
        popoverPresentationController?.sourceView = self.view
        popoverPresentationController?.sourceRect = buttonStackView.convert(buttonStackView.arrangedSubviews[0].frame, to: self.view)
        
    }
    
    @IBAction func vehicleButtonTapped(_ sender: UIButton){
        let presentingController: VehiclesController
        presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VehiclesController") as! VehiclesController
        presentingController.delegate = self
        presentingController.isAvailable = true
        presentingController.modalPresentationStyle = UIModalPresentationStyle.popover
        present(presentingController, animated: true, completion: nil)
        
        presentingController.preferredContentSize = CGSize(width: 400, height: 400)
        
        let popoverPresentationController = presentingController.popoverPresentationController
        popoverPresentationController?.sourceView = self.view
        popoverPresentationController?.sourceRect = buttonStackView.convert(buttonStackView.arrangedSubviews[1].frame, to: self.view)
        
    }
    
    func refreshDriver() {
        driverButton.setTitle("Driver: "+selectedDriver, for: .normal)
    }
    
    func refreshVehicle() {
        vehicleButton.setTitle("Vehicle: "+selectedVehicle, for: .normal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeLocations.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.locationsTable!.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        if(indexPath.row == routeLocations.count)
        {
            cell = self.locationsTable!.dequeueReusableCell(withIdentifier: "AddCell") as! LocationCell
            cell.textLabel?.text = "+"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 90, weight:UIFont.Weight.ultraLight)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.init(red: 128/255, green: 25/255, blue: 50/255, alpha: 1)
        }
        else
        {
            cell.seqNo.text = String(indexPath.row + 1)
            cell.populateCell(routeLocations[indexPath.row])
        }
//        cell.populateCell(allRoutes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.row == routeLocations.count)
        {
            let presentingController: LocationsController
            presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationsController") as! LocationsController
            presentingController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
            presentingController.delegate = self
            presentingController.prevLocation = self.myLocation ?? [Location]()
            present(presentingController, animated: true, completion: nil)
        }
//        performSegue(withIdentifier: "RouteDetails", sender: self)
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        if isEditMode{
            var customerIDs = ""
            if self.routeLocations.count != 1 {
                var count = 0
                for location in self.routeLocations{
                    count = count + 1
                    customerIDs.append(contentsOf: String(location.CustomerId))
                    if count != self.routeLocations.count{
                        customerIDs.append(",")
                    }
                }
            } else {
                customerIDs.append(contentsOf: String(self.routeLocations[0].CustomerId))
            }
            let jsonBody = [
                "RouteNo":self.routeNumber ?? 0,
                "RouteName": routeName.text ?? "",
                "DriverId": selectedDriverID ?? self.myRoute?.DriverId ?? 0,
                "VehicleNo": selectedVehicle,
                "CustomerID": customerIDs
                ] as [String : Any]
            
            RestManager.APIData(url: baseURL + editRoute, httpMethod: RestManager.HttpMethod.post.self.rawValue, body: SerializedData(JSONObject: jsonBody)){Data,Error in
                if Data != nil {
                    do {
                        let resultData = try JSONDecoder().decode(RequestResult.self, from: Data as! Data)
                        if resultData.Result == "success"{
                            self.message = "Route Updated"
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: self.message, message: nil, preferredStyle: .alert)
                                 self.present(alert, animated: true, completion: {
                                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_ ) in
                                        self.dismiss(animated: true, completion: {self.cancelButtonClicked()}) }
                                })
                            }
                        } else {
                            self.message = resultData.Result
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: self.message, message: nil, preferredStyle: .alert)
                                 self.present(alert, animated: true, completion: {
                                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_ ) in
                                        self.dismiss(animated: true, completion: {self.cancelButtonClicked()}) }
                                })
                            }
                        }
                        
                    } catch let JSONErr{
                        self.message = JSONErr.localizedDescription
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: self.message, message: nil, preferredStyle: .alert)
                             self.present(alert, animated: true, completion: {
                                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_ ) in
                                    self.dismiss(animated: true, completion: {self.cancelButtonClicked()}) }
                            })
                        }
                    }
                }
            }
        } else {
            var customerIDs = ""
            if routeLocations.count != 1 {
                var count = 0
                for location in routeLocations{
                    count = count + 1
                    customerIDs.append(contentsOf: String(location.CustomerId))
                    if count != routeLocations.count{
                        customerIDs.append(",")
                    }
                }
            } else {
                customerIDs.append(contentsOf: String(routeLocations[0].CustomerId))
            }
            let jsonBody = [
                "RouteName": routeName.text ?? "",
                "DriverId": selectedDriverID!,
                "VehicleNo": selectedVehicle,
                "CustomerID": customerIDs
                ] as [String : Any]
            
            RestManager.APIData(url: baseURL + addRoute, httpMethod: RestManager.HttpMethod.post.self.rawValue, body: SerializedData(JSONObject: jsonBody)){Data,Error in
                if Error == nil {
                    do {
                        let resultData = try JSONDecoder().decode(RequestResult.self, from: Data as! Data)
                        if resultData.Result == "success"{
                            self.message = "Route Added"
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: self.message, message: nil, preferredStyle: .alert)
                                 self.present(alert, animated: true, completion: {
                                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_ ) in
                                        self.dismiss(animated: true, completion: {self.cancelButtonClicked()}) }
                                })
                            }
                        } else {
                            self.message = resultData.Result
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: self.message, message: nil, preferredStyle: .alert)
                                 self.present(alert, animated: true, completion: {
                                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_ ) in
                                        self.dismiss(animated: true, completion: {self.cancelButtonClicked()}) }
                                })
                            }
                        }
                        
                    } catch let JSONErr{
                        self.message = JSONErr.localizedDescription
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: self.message, message: nil, preferredStyle: .alert)
                             self.present(alert, animated: true, completion: {
                                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_ ) in
                                    self.dismiss(animated: true, completion: {self.cancelButtonClicked()}) }
                            })
                        }
                    }
                }
            }
        }
    }
    @IBAction func cancelButtonClicked(){
        existingRouteController?.viewDidLoad()
        self.dismiss(animated: true, completion: nil)
    }
}
