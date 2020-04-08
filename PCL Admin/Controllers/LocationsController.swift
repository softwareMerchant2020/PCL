//
//  LocationsController.swift
//  PCL Admin
//
//  Created by Anish Verma on 1/2/19.
//  Copyright © 2019 Abihshek. All rights reserved.
//

import UIKit

class LocationsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var addButton: UIButton!
    var allLocations: [Location] = []
    var delegate: RoutesEditor?
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 8
        if let path = Bundle.main.path(forResource: "AllRoutes", ofType: "plist") {
            let routes = NSArray(contentsOfFile: path)
            for aRoute in routes!
            {
                let thisRoute = Route(aRoute as! [String : Any])!
                self.allLocations.append(contentsOf: thisRoute.locations)
            }
        }
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddLocationCell") as! AddLocationCell
        cell.populateCell(allLocations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var selectedLocation = allLocations[indexPath.row]
        selectedLocation.isSelected = !selectedLocation.isSelected
        allLocations.remove(at: indexPath.row)
        allLocations.insert(selectedLocation, at: indexPath.row)
        tableView.reloadData()
//        performSegue(withIdentifier: "RouteDetails", sender: self)
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton)
    {
        for aLocation in allLocations
        {
            if aLocation.isSelected
            {
                self.delegate?.routeLocations.append(aLocation)
            }
        }
        self.delegate?.locationsTable.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
}
