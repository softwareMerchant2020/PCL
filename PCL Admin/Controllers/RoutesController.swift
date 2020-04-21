//
//  ViewController.swift
//  PCL Admin
//
//  Created by Abihshek on 12/20/18.
//  Copyright © 2018 Abihshek. All rights reserved.
//

import UIKit

class RoutesController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var routesTable: UITableView?
    
    var allRoutes : [Route] = []
    var getRoutes : [RouteDetail] = []
    var routeDictionary: [Int:Any]? = [:]
    var routeNumbers: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routeNumbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.routesTable!.dequeueReusableCell(withIdentifier: "RouteCell") as! RouteCell
        cell.populateCell(self.routeDictionary?[routeNumbers[indexPath.row]] as? [RouteDetail] ?? [RouteDetail]())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UserDefaults.standard.set(routeNumbers[indexPath.row], forKey: "RouteNumberForMap")
        performSegue(withIdentifier: "RouteDetails", sender: self)
    }
    
    
}

