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
    var isEditMode = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addDriver))
        loadData()
    }
    @objc func addDriver()  {
        let presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DriverController") as! DriverController
        presentingController.delegate = self
        presentingController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        self.present(presentingController, animated: true, completion: nil)
    }
    
    func loadData()  {
        RestManager.APIData(url: baseURL + getDriver, httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){
            (Data, Error) in
            if Error == nil{
                do {
                    self.drivers = try JSONDecoder().decode([Driver].self, from: Data as! Data )
                    DispatchQueue.main.async {
                        if self.isEditMode {
                            self.driversTable.register(UINib(nibName: "DriverEditTableViewCell", bundle: .main), forCellReuseIdentifier: "DriverEditTableViewCell")
                        }
                        self.driversTable.reloadData()
                    }
                } catch let JSONErr{
                    print(JSONErr.localizedDescription)
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isEditMode {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            cell.textLabel?.text = drivers[indexPath.row].DriverName
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DriverEditTableViewCell", for: indexPath) as! DriverEditTableViewCell
            cell.setCellData(driver: drivers[indexPath.row])
            cell.viewController = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isEditMode {
            tableView.deselectRow(at: indexPath, animated: true)
            delegate?.selectedDriver = drivers[indexPath.row].DriverName
            delegate?.selectedDriverID = drivers[indexPath.row].DriverId
            delegate?.refreshDriver()
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            tableView.deselectRow(at: indexPath, animated: true)
            let presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DriverController") as! DriverController
            presentingController.delegate = self
            presentingController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
            self.present(presentingController, animated: true, completion: {
                presentingController.setValuesForInputField(driver: self.drivers[indexPath.row])
            })
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteDriver(driverObj: self.drivers[indexPath.row])
            drivers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func refreshTable() {
        self.loadData()
        self.driversTable.layoutSubviews()
    }
    func deleteDriver(driverObj:Driver)  {
        RestManager.APIData(url: baseURL + deleteDriverAPI + String(driverObj.DriverId), httpMethod: RestManager.HttpMethod.post.self.rawValue, body: nil) { (result, error) in
                if (error == nil) {
                    do {
                        let resultdata = try JSONDecoder().decode(RequestResult.self, from: result as! Data)
                        DispatchQueue.main.async {
                        let alert = UIAlertController(title:resultdata.Result, message: nil, preferredStyle: .alert)
                        self.present(alert, animated: true, completion: {
                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_ ) in
                            self.dismiss(animated: true, completion: {
                            self.driversTable.reloadData()
                            }) }
                        })
                    }
                    } catch {
                            print("Decode error:\(error.localizedDescription)")
                        }
                    }
        }
    }
}
