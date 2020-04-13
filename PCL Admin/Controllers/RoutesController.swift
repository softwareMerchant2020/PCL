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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let path = Bundle.main.path(forResource: "AllRoutes", ofType: "plist") {
            let routes = NSArray(contentsOfFile: path)
            for aRoute in routes!
            {
                self.allRoutes.append(Route(aRoute as! [String : Any])!)
            }
        }
        
        RestManager.APIData(url: "", httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){Data,Error in
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRoutes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.routesTable!.dequeueReusableCell(withIdentifier: "RouteCell") as! RouteCell
        cell.populateCell(allRoutes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "RouteDetails", sender: self)
    }
}

