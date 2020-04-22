//
//  ExistingRoutesController.swift
//  PCL Admin
//
//  Created by Anish Verma on 1/2/19.
//  Copyright © 2019 Abihshek. All rights reserved.
//

import UIKit

class ExistingRoutesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var routesTable: UITableView?
    var getRoutes : [GetRoute] = []
    var editRoutes : [EditRoute] = []
    var getDrivers : [Driver]? = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWIllAPpear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("ViewDidAppear")
    }
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
        RestManager.APIData(url: baseURL + getRoute, httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){Data,Error in
            if Error == nil{
                do {
                    self.getRoutes = try JSONDecoder().decode([GetRoute].self, from: Data as! Data )
                    DispatchQueue.main.async {
                        self.routesTable?.reloadData()
                    }
                } catch let JSONErr{
                    print(JSONErr)
                }
            }
        }
        RestManager.APIData(url: baseURL + getDriver, httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){Data,Error in
            if Error == nil{
                do {
                    self.getDrivers = try JSONDecoder().decode([Driver].self, from: Data as! Data )
                    DispatchQueue.main.async {
                        self.routesTable?.reloadData()
                    }
                } catch let JSONErr{
                    print(JSONErr)
                }
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getRoutes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.routesTable!.dequeueReusableCell(withIdentifier: "EditRouteCell") as! EditRouteCell
        let driver =  self.getDrivers?.filter({$0.DriverId == self.getRoutes[indexPath.row].Route.DriverId}).first
        cell.populateCell(self.getRoutes[indexPath.row].Route, driver:driver?.DriverName ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = baseURL + getRouteDetail + "?RouteNumber=" + String(getRoutes[indexPath.row].Route.RouteNo ?? 0)
        RestManager.APIData(url: url, httpMethod: RestManager.HttpMethod.post.self.rawValue, body: nil){Data,Error in
            if Error == nil{
                do {
                    self.editRoutes = try JSONDecoder().decode([EditRoute].self, from: Data as! Data )
                    DispatchQueue.main.async {
                        tableView.deselectRow(at: indexPath, animated: true)
                        let presentingController: RoutesEditor
                        presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoutesEditor") as! RoutesEditor
                        presentingController.isEditMode = true
                        presentingController.myRoute = self.editRoutes[0].Route
                        let driver =  self.getDrivers?.filter({$0.DriverId == self.editRoutes[0].Route.DriverId}).first
                        presentingController.driverName = driver?.DriverName
                        presentingController.myLocation = self.editRoutes[0].Customer
                        presentingController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
                        self.present(presentingController, animated: true, completion: nil)
                        //        performSegue(withIdentifier: "RouteDetails", sender: self)
                        
                    }
                } catch let JSONErr{
                    print(JSONErr)
                }
            }
        }
    }
}
