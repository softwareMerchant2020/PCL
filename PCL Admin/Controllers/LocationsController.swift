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
    @IBOutlet weak var locationTableView: UITableView!
    var delegate: RoutesEditor?
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 8
        RestManager.APIData(url: baseURL + getAvailableCustomer, httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){Data,Error in
            if Error == nil{
                do {
                    self.allLocations = try JSONDecoder().decode([Location].self, from: Data as! Data )
                    DispatchQueue.main.async {
                        self.locationTableView.reloadData()
                    }
                } catch let JSONErr{
                    print(JSONErr)
                }
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
        selectedLocation.IsSelected = !selectedLocation.IsSelected
        allLocations.remove(at: indexPath.row)
        allLocations.insert(selectedLocation, at: indexPath.row)
        tableView.reloadData()
//        performSegue(withIdentifier: "RouteDetails", sender: self)
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton)
    {
        for aLocation in allLocations
        {
            if aLocation.IsSelected
            {
                self.delegate?.routeLocations.append(aLocation)
            }
        }
        self.delegate?.locationsTable.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
}
