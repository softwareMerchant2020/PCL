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
    @IBOutlet var vehicleButton: UIButton!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    var myRoute: Route?
    
    var selectedDriver: String = "   ---   "
    var selectedVehicle: String = "   ---   "
    var routeLocations: [Location] = []
    
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
        
        if let aRoute = myRoute {
            self.routeName.text = aRoute.routeName
            self.selectedDriver = aRoute.assignee
            self.selectedVehicle = aRoute.vehicleNo
            self.routeLocations = aRoute.locations
        }
        refreshDriver()
        refreshVehicle()
    }
    
    @IBAction func driverButtonTapped(_ sender: UIButton){
        let presentingController: DriversController
        presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DriversController") as! DriversController
        presentingController.delegate = self
        presentingController.modalPresentationStyle = UIModalPresentationStyle.popover
        present(presentingController, animated: true, completion: nil)
        
        presentingController.preferredContentSize = CGSize(width: 400, height: 400)
        
        let popoverPresentationController = presentingController.popoverPresentationController
        popoverPresentationController?.sourceView = self.view
        popoverPresentationController?.sourceRect = sender.frame
        
    }
    
    @IBAction func vehicleButtonTapped(_ sender: UIButton){
        let presentingController: VehiclesController
        presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VehiclesController") as! VehiclesController
        presentingController.delegate = self
        presentingController.modalPresentationStyle = UIModalPresentationStyle.popover
        present(presentingController, animated: true, completion: nil)
        
        presentingController.preferredContentSize = CGSize(width: 400, height: 400)
        
        let popoverPresentationController = presentingController.popoverPresentationController
        popoverPresentationController?.sourceView = self.view
        popoverPresentationController?.sourceRect = sender.frame
        
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
            present(presentingController, animated: true, completion: nil)
        }
//        performSegue(withIdentifier: "RouteDetails", sender: self)
    }
    
    @IBAction func cancelButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
}
