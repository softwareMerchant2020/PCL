//
//  DriversControllerViewController.swift
//  PCL Admin
//
//  Created by Anish Verma on 12/31/18.
//  Copyright © 2018 Abihshek. All rights reserved.
//

import UIKit

class DriversController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var driversTable: UITableView!
    var delegate: RoutesEditor?
    var drivers = [Driver]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestManager.APIData(url: baseURL + getDriver, httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){
            (Data, Error) in
            if Error == nil{
                do {
                    self.drivers = try JSONDecoder().decode([Driver].self, from: Data as! Data )
                    DispatchQueue.main.async {
                        self.driversTable.reloadData()
                    }
                } catch let JSONErr{
                    print(JSONErr.localizedDescription)
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = drivers[indexPath.row].DriverName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.selectedDriver = drivers[indexPath.row].DriverName
        delegate?.selectedDriverID = drivers[indexPath.row].DriverId
        delegate?.refreshDriver()
        self.dismiss(animated: true, completion: nil)
        
    }
}
