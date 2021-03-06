//
//  ViewController.swift
//  PCL Admin
//
//  Created by Abihshek on 12/20/18.
//  Copyright © 2018 Abihshek. All rights reserved.
//

import UIKit

class RoutesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var TotalSpecimensLbl: UILabel!
    
    @IBOutlet var routesTable: UITableView?
    
    var allRoutes : [Route] = []
    var getRoutes : [RouteDetail] = []
    var routeDictionary: [Int:Any]? = [:]
    var routeNumbers: [Int] = []
    var drivers:[Driver]?
    var routesData = [GetRoute]()
    var driverLocs:Dictionary<Int, DriverLocation> = Dictionary<Int, DriverLocation>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.routesTable?.addSubview(self.refreshControl)
        RestManager.APIData(url: baseURL + getAdminDetails, httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){Data,Error in
            if Error == nil{
                do {
                    self.getRoutes = try JSONDecoder().decode([RouteDetail].self, from: Data as! Data )
                    for eachResult in self.getRoutes {
                        if (self.routeDictionary?[eachResult.RouteNo] == nil) {
                            var eachRoute : [RouteDetail] = []
                            self.routeNumbers.append(eachResult.RouteNo)
                            eachRoute.append(eachResult)
                            self.routeDictionary?[eachResult.RouteNo] = eachRoute
                        }
                        else
                        {
                            var dataArr = self.routeDictionary?[eachResult.RouteNo] as! [RouteDetail]
                            dataArr.append(eachResult)
                            self.routeDictionary?[eachResult.RouteNo] = dataArr
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.routesTable?.dataSource = self
                        self.routesTable?.delegate = self
                        self.routesTable?.reloadData()
                    }
                } catch let JSONErr{
                    print(JSONErr)
                }
            }
        }
        totalSpecimensCollected()
        getDrivers()
        getRoutesData()
    }
    
    func getDrivers(){
        RestManager.APIData(url: baseURL + getDriver, httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){Data,Error in
            if Error == nil{
                do {
                    self.drivers = try JSONDecoder().decode([Driver].self, from: Data as! Data )
                    self.getDriverLocations(drivers: self.drivers ?? [])
                    DispatchQueue.main.async {
                        self.routesTable?.dataSource = self
                        self.routesTable?.delegate = self
                        self.routesTable?.reloadData()
                    }
                } catch let JSONErr{
                    print(JSONErr)
                }
            }
        }
    }
    
    func getDriverLocations(drivers:[Driver]) {
        for aDriver in drivers {
            RestManager.APIData(url: baseURL + getDriverLocation + "?DriverId=" + String(aDriver.DriverId), httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){
                (Data, Error) in
                if Error == nil{
                    do {
                        let driverLoc = try JSONDecoder().decode([DriverLocation].self, from: Data as! Data )
                        self.driverLocs[aDriver.DriverId] = driverLoc[0]
                        DispatchQueue.main.async {
                            self.routesTable?.dataSource = self
                            self.routesTable?.delegate = self
                            self.routesTable?.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
                }}
    }
    
    func totalSpecimensCollected()  {
        RestManager.APIData(url: baseURL + getTotalSpecimensCollected, httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){Data,Error in
            if Error == nil{
                do {
                    let totalSpecimensCollected = try JSONDecoder().decode(TotalNumberOfSpecimens.self, from: Data as! Data )
                    
                    DispatchQueue.main.async {
                        self.TotalSpecimensLbl.text = String(totalSpecimensCollected.TotalNumberOfSpecimens)
                    }
                } catch let JSONErr{
                    print(JSONErr)
                }
            }
        }
    }
    
    func getRoutesData(){
        RestManager.APIData(url: baseURL + getRoute, httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){Data,Error in
            if Error == nil{
                do {
                    self.routesData = try JSONDecoder().decode([GetRoute].self, from: Data as! Data )
                    DispatchQueue.main.async {
                        self.routesTable?.dataSource = self
                        self.routesTable?.delegate = self
                        self.routesTable?.reloadData()
                    }
                } catch let JSONErr{
                    print(JSONErr)
                }
            }
        }
    }
    
    
    
    @objc func getAdminData(_ refreshControl: UIRefreshControl){
        self.routeNumbers.removeAll()
        self.routeDictionary?.removeAll()
        self.getRoutes.removeAll()
        totalSpecimensCollected()
        getDrivers()
        getRoutesData()
        RestManager.APIData(url: baseURL + getAdminDetails, httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){Data,Error in
            if Error == nil{
                do {
                    self.getRoutes = try JSONDecoder().decode([RouteDetail].self, from: Data as! Data )
                    for eachResult in self.getRoutes {
                        if (self.routeDictionary?[eachResult.RouteNo] == nil) {
                            var eachRoute : [RouteDetail] = []
                            self.routeNumbers.append(eachResult.RouteNo)
                            eachRoute.append(eachResult)
                            self.routeDictionary?[eachResult.RouteNo] = eachRoute
                        }
                        else
                        {
                            var dataArr = self.routeDictionary?[eachResult.RouteNo] as! [RouteDetail]
                            dataArr.append(eachResult)
                            self.routeDictionary?[eachResult.RouteNo] = dataArr
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.routesTable?.dataSource = self
                        self.routesTable?.delegate = self
                        self.routesTable?.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                } catch let JSONErr{
                    print(JSONErr)
                }
            }
        }
    }
    
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.getAdminData(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routeNumbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.routesTable!.dequeueReusableCell(withIdentifier: "RouteCell") as! RouteCell
        let route = self.routesData.filter { (routeObj) -> Bool in
            routeObj.Route.RouteNo == routeNumbers[indexPath.row]
        }.first
        cell.populateCell(self.routeDictionary?[routeNumbers[indexPath.row]] as? [RouteDetail] ?? [RouteDetail](), drivers: self.drivers, routeData:route, driversLocs: self.driverLocs)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UserDefaults.standard.set(routeNumbers[indexPath.row], forKey: "RouteNumberForMap")
        let presentingController: RouteDetailsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RouteDetails") as! RouteDetailsController
        UserDefaults.standard.set(Int(self.getRoutes[indexPath.row].UpdatedByDriver), forKey: "DriverNumber")
        presentingController.routeNumber = self.getRoutes[indexPath.row].RouteNo
        performSegue(withIdentifier: "RouteDetails", sender: self)
    }
}

