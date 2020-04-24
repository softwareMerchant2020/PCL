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
    var isEditMode = false
    var isAvailable:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addVehicle))
        loadData()
    }
    func loadData()  {
        var urlStr:String!
        
        if !isAvailable {
            urlStr = baseURL + getVehicle
        }
        else {
            urlStr = baseURL + getAvailableVehicle
        }
        
        RestManager.APIData(url: urlStr, httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){
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
    @objc func addVehicle() {
        let presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddVehiclesViewController") as! AddVehiclesViewController
        presentingController.delegate = self
        presentingController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        self.present(presentingController, animated: true, completion: nil)
        
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
        if !isEditMode {
            tableView.deselectRow(at: indexPath, animated: true)
            delegate?.selectedVehicle = vehicles?[indexPath.row].PlateNumber ?? ""
            delegate?.refreshVehicle()
            self.dismiss(animated: true, completion: nil)
        }
        else {
            tableView.deselectRow(at: indexPath, animated: true)
            let presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddVehiclesViewController") as! AddVehiclesViewController
            presentingController.delegate = self
            presentingController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
            self.present(presentingController, animated: true, completion: {
                presentingController.updateVehicleInfo(vehicle: (self.vehicles?[indexPath.row])!)
            })
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteVehicle(vehicleId: (vehicles?[indexPath.row].VehicleId)!)
            vehicles?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func deleteVehicle(vehicleId:Int)  {
        
        RestManager.APIData(url: baseURL + deleteVehicleAPI + String(vehicleId), httpMethod: RestManager.HttpMethod.post.self.rawValue, body: nil) { (result, error) in
                       if (error == nil) {
                           do {
                               let resultdata = try JSONDecoder().decode(RequestResult.self, from: result as! Data)
                               DispatchQueue.main.async {
                               let alert = UIAlertController(title:resultdata.Result, message: nil, preferredStyle: .alert)
                               self.present(alert, animated: true, completion: {
                               Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_ ) in
                                   self.dismiss(animated: true, completion: {
                                   self.vehiclesTable.reloadData()
                                   }) }
                               })
                           }
                           } catch {
                                   print("Decode error:\(error.localizedDescription)")
                               }
                           }
               }
        
    }
    func refreshTable() {
        self.loadData()
        self.vehiclesTable.layoutSubviews()
    }
}
