//
//  VehiclesController.swift
//  PCL Admin
//
//  Created by Anish Verma on 1/2/19.
//  Copyright © 2019 Abihshek. All rights reserved.
//

import UIKit

class VehiclesController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var vehiclesTable: UITableView!
    var delegate: RoutesEditor?
    var vehicles: [Vehicle]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestManager.APIData(url: baseURL + getVehicle, httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){
                  (Data, Error) in
                  if Error == nil{
                      do {
                          self.vehicles = try JSONDecoder().decode([Vehicle].self, from: Data as! Data )
                          DispatchQueue.main.async {
                              self.vehiclesTable.reloadData()
                          }
                      } catch let JSONErr{
                          print(JSONErr.localizedDescription)
                      }
                  }
              }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = vehicles?[indexPath.row].PlateNumber
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.selectedVehicle = vehicles?[indexPath.row].PlateNumber ?? ""
        delegate?.refreshVehicle()
        self.dismiss(animated: true, completion: nil)
        
    }
}
