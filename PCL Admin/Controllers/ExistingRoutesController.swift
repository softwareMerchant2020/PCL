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
    var allRoutes : [Route] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let path = Bundle.main.path(forResource: "AllRoutes", ofType: "plist") {
            let routes = NSArray(contentsOfFile: path)
            for aRoute in routes!
            {
                self.allRoutes.append(Route(aRoute as! [String : Any])!)
            }
            routesTable?.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRoutes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.routesTable!.dequeueReusableCell(withIdentifier: "EditRouteCell") as! EditRouteCell
        cell.populateCell(allRoutes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let presentingController: RoutesEditor
        presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoutesEditor") as! RoutesEditor
        presentingController.myRoute = allRoutes[indexPath.row]
        presentingController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        present(presentingController, animated: true, completion: nil)
//        performSegue(withIdentifier: "RouteDetails", sender: self)
    }
}
